import 'package:flutter/material.dart';

class GuiaPage extends StatelessWidget {
  const GuiaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guía de Cuidado de Crías'),
        backgroundColor: Color(0xFFFCE4EC),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/ali.png',
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'La guía definitiva de cuidado de crías',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Información detallada sobre el manejo de lechones y su cuidado.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  // Primer Card
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/ali.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                      title: Text('Cuidado de los Lechones'),
                      subtitle: Text(
                        'Leé tips para el cuidado de los lechones.',
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DetailScreen(
                              title1: 'Cuidado de los Lechones',
                              image1: 'assets/ali.png',
                              image2: 'assets/L.png',
                              image3: 'assets/al.png',
                              content:
                              'El cuidado de los lechones es crucial para su crecimiento saludable.',
                              sections: [
                                CustomSection(
                                  title:
                                  'Cuidados Inmediatos al Nacimiento',
                                  image: 'assets/L.png',
                                  content:
                                  'Después del parto, los lechones requieren atención inmediata para asegurar su supervivencia:',
                                  points: [
                                    'Secado y Estimulación: Usar un paño limpio para secarlos y estimular la respiración.',
                                    'Acceso al Colostro: Los lechones deben mamar dentro de las primeras 6 horas para obtener inmunidad.',
                                    'Corte y Desinfección del Cordón Umbilical: Usar yodo para prevenir infecciones.',
                                    'Temperatura Adecuada: Debe mantenerse entre 30-35°C, ya que los lechones no regulan bien su temperatura.',
                                  ],
                                  careTitle: 'Cuidados recomendados',
                                  pointsColor: Colors.green,
                                ),
                                CustomSection(
                                  title: 'Alimentación y Nutrición',
                                  image: 'assets/al.png',
                                  content:
                                  'Los protocolos aseguran la salud de los lechones.',
                                  points: [
                                    'Lactancia Materna: Es la fuente principal de nutrientes durante los primeros días.',
                                    'Suplementos: A partir de los 7 días, se puede introducir alimento sólido gradualmente.',
                                    'Hierro: Los lechones necesitan un suplemento de hierro (inyección entre el día 2 y 3) para prevenir la anemia.',
                                  ],
                                  careTitle: 'Cuidados Generales',
                                  pointsColor: Colors.blue,
                                ),
                                CustomSection(
                                  title:
                                  'Salud y Prevención de Enfermedades',
                                  image: 'assets/ali.png',
                                  content:
                                  'Monitorear la salud es clave para prevenir enfermedades.',
                                  points: [
                                    'Vacunación: Se deben seguir los protocolos veterinarios según la granja.',
                                    'Signos de Enfermedad,Falta de apetito, Lechones débiles o temblorosos, Diarrea o vómito',
                                  ],
                                  careTitle: 'Bienestar y Salud',
                                  pointsColor: Colors.orange,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Segundo Card
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/cerdas.jpg',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                      title: Text('Guía de Protocolos de Cuidado de Cerdas'),
                      subtitle: Text(
                        'Leé los protocolos para cuidar a las cerdas en labor de parto.',
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DetailScreen(
                              title1: 'Protocolos de Cuidados',
                              image1: 'assets/cerdas.jpg',
                              image2: 'assets/gest.png',
                              image3: 'assets/gestante.png',
                              content:
                              'El cuidado adecuado de las cerdas es esencial para su salud, bienestar y productividad en la granja. Esta guía detalla los protocolos en cada etapa de su vida reproductiva.',
                              sections: [
                                CustomSection(
                                  title: 'Cuidado de la Cerda Gestante',
                                  image: 'assets/gest.png',
                                  content:
                                  'Duración de la Gestación: 114 días (aprox. 3 meses, 3 semanas y 3 días).',
                                  points: [
                                    'Última Semana Antes del Parto:Trasladar a la paridera limpia y desinfectada.',
                                    'Observar signos de parto (inquietud, secreción láctea).',
                                  ],
                                  careTitle: 'Manejo Preparto',
                                  pointsColor: Colors.red,
                                ),
                                CustomSection(
                                  title: 'Cuidado Durante el Parto',
                                  image: 'assets/cria.png',
                                  content:
                                  'Duración: Puede tardar de 2 a 6 horas.',
                                  points: [
                                    'Asistir si hay complicaciones o retrasos entre lechones.',
                                    'Limpiar y secar a los lechones al nacer.',
                                  ],
                                  careTitle: 'Supervisión:',
                                  pointsColor: Colors.purple,
                                ),
                                CustomSection(
                                  title:
                                  'Bienestar y Prevención de Enfermedades',
                                  image: 'assets/gestante.png',
                                  content:
                                  'Seguimiento de protocolos sanitarios.',
                                  points: [
                                    'Espacios ventilados, limpios y sin hacinamiento.',
                                    'Temperatura entre 18-22°C para cerdas adultas.',
                                  ],
                                  careTitle: 'Condiciones Óptimas:',
                                  pointsColor: Colors.yellow,
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
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String title1;
  final String content;
  final String image1;
  final String image2;
  final String image3;
  final List<CustomSection> sections;

  DetailScreen({
    required this.title1,
    required this.content,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title1), backgroundColor: Color(0xFFFCE4EC)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image1,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              title1,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(content),
            SizedBox(height: 20),
            // Mostrar las secciones
            for (var section in sections) section,
          ],
        ),
      ),
    );
  }
}

class CustomSection extends StatelessWidget {
  final String title;
  final String content;
  final String image;
  final List<String> points;
  final String careTitle;
  final Color pointsColor;

  CustomSection({
    required this.title,
    required this.content,
    required this.image,
    required this.points,
    required this.careTitle,
    required this.pointsColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(content),
        SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            image,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 16),
        Text(
          careTitle,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Column(
          children:
          points.map((point) {
            return Row(
              children: [
                Icon(Icons.check_circle, color: pointsColor, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(point, style: TextStyle(fontSize: 16)),
                ),
              ],
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
