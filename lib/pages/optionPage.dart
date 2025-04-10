import 'package:flutter/material.dart';
import 'package:mi_aplicacion/pages/calendarpage.dart';
import 'package:mi_aplicacion/pages/guidePage.dart';
import 'package:mi_aplicacion/pages/registrarCerdosPage.dart';
import 'package:mi_aplicacion/pages/perfilCerdoPage.dart';
import 'db_helper.dart';

final GlobalKey<_HomePageState> homePageKey = GlobalKey<_HomePageState>();

class OptionPage extends StatefulWidget {
  const OptionPage({Key? key}) : super(key: key);

  @override
  _OptionPageState createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  int _selectedIndex = 1; // Página inicial

  // Lista de páginas
  final List<Widget> _pages = [
    const CalendarPage(),
    HomePage(key: homePageKey),
    const GuiaPage(),
  ];

  // Método para navegar a la página de registrar cerdos
  void _navigateToRegistrarCerdo() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrarCerdo()),
    );

    // Accede al estado de HomePage usando la clave
    homePageKey.currentState?.loadCerdos();
  }

  // Método para navegar al perfil del cerdo
  void _navigateToPerfilCerdo(int cerdoId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PerfilCerdo(cerdoId: cerdoId)),
    );

    // Al regresar, recarga los cerdos para asegurarte de que la etapa esté actualizada
    homePageKey.currentState?.loadCerdos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 1 // Solo muestra AppBar en HomePage
          ? AppBar(
        title: const Text('Página Principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, size: 50),
            iconSize: 90,
            color: Colors.deepPurple,
            onPressed: _navigateToRegistrarCerdo,
          ),
        ],
      )
          : null, // No muestra AppBar en otras páginas
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Calendario'),
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Guías'),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _cerdos = []; // Lista para almacenar los cerdos
  List<Map<String, dynamic>> _filteredCerdos = []; // Lista para almacenar cerdos filtrados
  final TextEditingController _searchController = TextEditingController(); // Controlador para el campo de búsqueda

  @override
  void initState() {
    super.initState();
    _loadCerdos(); // Cargar los cerdos al iniciar
    _searchController.addListener(_filterCerdos);
  }

  // Método público para que pueda ser llamado desde OptionPage
  Future<void> loadCerdos() async {
    await _loadCerdos();
  }

  Future<void> _loadCerdos() async {
    final cerdos = await _dbHelper.getAllCerdos();
    setState(() {
      _cerdos = cerdos; // Actualizar el estado con la lista de cerdos
      _filteredCerdos = cerdos; // Inicialmente, todos los cerdos están filtrados
    });
  }

  void _filterCerdos() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCerdos = _cerdos.where((cerdo) {
        return cerdo['identificacion'].toString().toLowerCase().contains(query); // Filtrar por ID
      }).toList();
    });
  }

  // Método para filtrar cerdos por raza
  void _filterByRaza(String raza) {
    setState(() {
      _filteredCerdos = _cerdos.where((cerdo) {
        return cerdo['etapa'].toString().toLowerCase() == raza.toLowerCase(); // Filtrar por etapa
      }).toList();
    });
  }

  // Método para mostrar todos los cerdos
  void _showAllCerdos() {
    setState(() {
      _filteredCerdos = List.from(_cerdos); // Mostrar todos los cerdos
    });
  }

  // Método para eliminar un cerdo
  Future<void> _deleteCerdo(int id) async {
    await _dbHelper.deleteCerdo(id);
    loadCerdos(); // Recargar los cerdos después de eliminar
  }

  void _confirmDeleteCerdo(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar Eliminación"),
          content: const Text("¿Estás seguro de que deseas eliminar este cerdo?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                _deleteCerdo(id); // Eliminar el cerdo
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController, // Asignar el controlador
            decoration: InputDecoration(
              hintText: 'Buscar Cerditos por ID...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryCard(
                    'Lactante',
                    'assets/lechones.jpg',
                    onTap: () => _filterByRaza('Lactante'), // Filtrar por raza Lechon
                  ),
                  const SizedBox(width: 20),
                  CategoryCard(
                    'Gestante',
                    'assets/cerdoreproductora.jpg',
                    onTap: () => _filterByRaza('Gestante'), // Filtrar por raza Reproductora
                  ),
                  const SizedBox(width: 20),
                  CategoryCard(
                    'Crecimiento',
                    'assets/cerdoengorda.png',
                    onTap: () => _filterByRaza('Crecimiento'), // Filtrar por raza Engorde
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),
          // Botón "Ver todos" para mostrar todos los cerdos
          TextButton(
            onPressed: _showAllCerdos, // Llama a la función para mostrar todos los cerdos
            child: Text(
              "Ver todos",
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCerdos.length, // Usar la longitud de la lista filtrada
              itemBuilder: (context, index) {
                final cerdo = _filteredCerdos[index]; // Obtener el cerdo actual
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0), // Espaciado vertical
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/iconoUser.png'),
                    ),
                    title: Text(cerdo['identificacion']), // Mostrar ID del cerdo
                    subtitle: Text(cerdo['etapa'] ?? 'Sin etapa'), // Mostrar etapa
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Mostrar el diálogo de confirmación
                            _confirmDeleteCerdo(cerdo['id']);
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _navigateToPerfilCerdo(cerdo['id']); // Navegar al perfil del cerdo
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('View'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  // Método para navegar al perfil del cerdo
  void _navigateToPerfilCerdo(int cerdoId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PerfilCerdo(cerdoId: cerdoId)),
    );

    // Al regresar, recarga los cerdos para asegurarte de que la etapa esté actualizada
    loadCerdos(); // Recargar cerdos después de regresar
  }
}

// Tarjetas de Categoría
class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap; // Agregar  callback

  const CategoryCard(this.title, this.imagePath, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Llama al callback cuando se presiona la tarjeta
      child: Container(
        width: 140,
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
