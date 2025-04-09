import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para el formateo de fechas
import 'db_helper.dart';

class PerfilCerdo extends StatefulWidget {
  final int cerdoId;

  const PerfilCerdo({Key? key, required this.cerdoId}) : super(key: key);

  @override
  _PerfilCerdoState createState() => _PerfilCerdoState();
}

class _PerfilCerdoState extends State<PerfilCerdo> {
  bool isEditing = false;
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController razaController = TextEditingController();
  final TextEditingController historialController = TextEditingController(); // Controlador para el historial
  String etapaActual = "";
  Map<String, dynamic>? cerdoData;

  List<Map<String, dynamic>> _historialSalud = []; // Lista para almacenar el historial de salud

  @override
  void initState() {
    super.initState();
    _loadCerdoData();
  }

  Future<void> _loadCerdoData() async {
    final dbHelper = DatabaseHelper();
    final data = await dbHelper.getCerdoById(widget.cerdoId);

    if (data != null) {
      setState(() {
        cerdoData = data;
        pesoController.text = data['peso'].toString();
        razaController.text = data['raza'];
        etapaActual = data['etapa'];
      });

      // Cargar el historial de salud después de que se hayan cargado los datos del cerdo
      await _cargarHistorialSalud();
    }
  }

  Future<void> _cargarHistorialSalud() async {
    final dbHelper = DatabaseHelper();
    if (cerdoData != null) {
      // Obtener el historial del cerdo y hacer una copia de la lista
      List<Map<String, dynamic>> historial = await dbHelper.getHistorialSalud(cerdoData!['id']);
      setState(() {
        _historialSalud = List.from(historial); // Crear una copia de la lista
      });
    }
  }

  String calcularSemanas(String fechaNacimiento) {
    DateTime fechaNac = DateTime.parse(fechaNacimiento); // Convertir a DateTime
    DateTime hoy = DateTime.now(); // Obtener fecha actual
    int diasVividos = hoy.difference(fechaNac).inDays; // Diferencia en días
    int semanasVividas = (diasVividos / 7).floor(); // Convertir a semanas
    return "$semanasVividas semanas";
  }

  String calcularAlimento(double peso, int edadSemanas, String etapa) {
    if (edadSemanas < 4) {
      // Si es menor a 4 semanas, calcular en mililitros de leche
      double lecheDiaria = peso * 250; // 250 ml por kg de peso
      return "${lecheDiaria.toStringAsFixed(1)} ml de leche";
    } else {
      // Si es mayor, calcular en kg de alimento sólido
      double factorBase = 0.03; // 3% del peso
      switch (etapa.toLowerCase()) {
        case 'lactante':
          factorBase += 0.02;
          break;
        case 'gestante':
          factorBase += 0.015;
          break;
        case 'crecimiento':
          factorBase += 0.01;
          break;
        default:
          break;
      }
      if (edadSemanas > 24) {
        factorBase -= 0.01;
      }
      double alimentoDiario = peso * factorBase;
      alimentoDiario = alimentoDiario.clamp(0.5, 6.0); // Mínimo 500g, máximo 6kg

      return "${alimentoDiario.toStringAsFixed(2)} kg de alimento";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cerdoData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/splash.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: double.infinity,
                  height: 200,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cerdoData!['identificacion'],
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(
                          isEditing ? Icons.check : Icons.edit,
                          size: 20,
                        ),
                        label: Text(
                          isEditing ? "Guardar" : "Editar",
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isEditing ? Colors.green : Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        onPressed: () async {
                          if (isEditing) {
                            final dbHelper = DatabaseHelper();

                            // Actualizar datos del cerdo sin depender del historial
                            await dbHelper.updateCerdo(
                              cerdoData!['id'], // ID del cerdo
                              double.parse(pesoController.text),
                              razaController.text,
                              etapaActual,
                            );

                            // Mostrar mensaje de éxito
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Datos del cerdo actualizados")),
                            );

                            // Opcionalmente, puedes recargar el historial si lo deseas
                            await _cargarHistorialSalud();

                            setState(() {
                              isEditing = false; // Cambia a modo no edición
                            });
                          } else {
                            setState(() {
                              isEditing = true; // Cambia a modo edición
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _buildNonEditableField("Edad", calcularSemanas(cerdoData!['fecha_nacimiento']))),
                      Expanded(
                        child: isEditing
                            ? _buildEditableField("Peso", pesoController)
                            : _buildNonEditableField("Peso", "${pesoController.text} kg"),
                      ),
                      Expanded(
                        child: isEditing
                            ? _buildEditableField("Raza", razaController)
                            : _buildNonEditableField("Raza", razaController.text),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text("Alimento", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Menú Diario: ${calcularAlimento(
                                double.parse(pesoController.text),
                                int.parse(calcularSemanas(cerdoData!['fecha_nacimiento']).split(' ')[0]),
                                etapaActual
                            )}",
                          ),
                          Icon(Icons.restaurant, color: Colors.blue),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text("Etapa", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  isEditing
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStageButton("Lactante"),
                      _buildStageButton("Gestante"),
                      _buildStageButton("Crecimiento"),
                    ],
                  )
                      : Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(etapaActual, style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text("Historial de Salud", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  TextField(
                    controller: historialController,
                    decoration: InputDecoration(
                      hintText: "Describe...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  // Mostrar el botón de guardar solo si se está editando
                  if (isEditing) ...[
                    SizedBox(height: 8), // Espacio antes del botón
                    ElevatedButton(
                      onPressed: () async {
                        final dbHelper = DatabaseHelper();
                        if (cerdoData != null && historialController.text.isNotEmpty) {
                          await dbHelper.addHistorialSalud(cerdoData!['id'], historialController.text);
                          historialController.clear(); // Limpia el campo después de guardar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Historial de salud guardado")),
                          );
                          await _cargarHistorialSalud(); // Cargar el historial actualizado
                        }
                      },
                      child: Text("Guardar Historial"),
                    ),
                  ],
                  // Mostrar el historial de salud
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Evitar desplazamiento interno
                    itemCount: _historialSalud.length,
                    itemBuilder: (context, index) {
                      // Obtener la fecha y formatearla
                      String fechaStr = _historialSalud[index]['fecha'] ?? "Sin fecha";
                      DateTime fecha = DateTime.parse(fechaStr);
                      String fechaFormateada = DateFormat('dd/MM/yyyy HH:mm').format(fecha);

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0), // Margen reducido
                        elevation: 4, // Sombra de la tarjeta
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Esquinas redondeadas
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15.0), // Espaciado interno
                          child: Row( // Usar Row para tener el texto y el botón en la misma fila
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _historialSalud[index]['descripcion'],
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    Text(
                                      fechaFormateada,
                                      style: TextStyle(color: Colors.grey[600], fontSize: 14), // Color gris para la fecha
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _confirmDeleteHistorial(index); // Llama al método de confirmación
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNonEditableField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(value, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(
          width: 100,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(border: OutlineInputBorder()),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildStageButton(String stage) {
    return ElevatedButton(
      onPressed: () async {
        final dbHelper = DatabaseHelper();
        await dbHelper.updateCerdo(
          cerdoData!['id'],
          double.parse(pesoController.text),
          razaController.text,
          stage, // Actualiza la etapa
        );

        setState(() {
          etapaActual = stage; // Cambia la etapa actual
        });
      },
      child: Text(stage, style: TextStyle(fontSize: 16)),
    );
  }

  // Método para mostrar el diálogo de confirmación y eliminar el historial
  void _confirmDeleteHistorial(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar Eliminación"),
          content: const Text("¿Estás seguro de que deseas eliminar este registro del historial?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                final dbHelper = DatabaseHelper();
                // Eliminar el registro de la base de datos
                await dbHelper.deleteHistorialSalud(_historialSalud[index]['id']);
                // Eliminar el registro de la lista
                setState(() {
                  _historialSalud.removeAt(index); // Eliminar de la lista
                });
                Navigator.of(context).pop(); // Cerrar el diálogo
                // Mostrar mensaje de éxito
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Registro del historial eliminado")),
                );
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }
}
