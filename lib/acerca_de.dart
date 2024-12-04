import 'package:flutter/material.dart';

class AcercaDePage extends StatelessWidget {
  // Lista de desarrolladores
  final List<Map<String, String>> desarrolladores = [
    {
      'nombre': 'Jose Gonzalez',
      'matricula': '2021-0599',
      'foto': 'assets/desarrollador1.png',
      'reflexion': 'El esfuerzo siempre da frutos.',
    },
    {
      'nombre': 'Jeiron Matos Maños',
      'matricula': '2022-0733',
      'foto': 'assets/desarrollador2.png',
      'reflexion':
          'Soy un apasionado desarrollador web con conocimiento en tecnologías móviles, dedicado a crear soluciones innovadoras y funcionales. Actualmente, soy estudiante en el Instituto Tecnológico de Las Américas (ITLA), enfocándome en el diseño y desarrollo de aplicaciones que combinen creatividad y tecnología..',
    },
    {
      'nombre': 'Angel Peynado',
      'matricula': '2021-0923',
      'foto': 'assets/desarrollador3.png',
      'reflexion':
          'Soy un desarrollador web con experiencia en crear soluciones digitales innovadoras y eficientes. Además, soy especialista en el sector de la refrigeración, lo que le permite combinar tecnología y conocimiento técnico para diseñar proyectos que destacan por su funcionalidad y precisión. Actual mente soy estudiante de software en el (Itla) y maestro en tecnología de refrigeración .',
    },
    {
      'nombre': 'Cristipher Tolentino',
      'matricula': '2020-10703',
      'foto': 'assets/desarrollador4.png',
      'reflexion':
          'Soy  una persona apasionada por los videojuegos y el mundo de la programación. A demás de dedicar mi tiempo libre a explorar nuevos títulos y desafíos virtuales, mientras complemento mi pasión con el desarrollo constante acerca de lo que es la programación .',
    },
    {
      'nombre': 'Oriam ruiz then ',
      'matricula': '2023-0229',
      'foto': 'assets/desarrollador5.png',
      'reflexion':
          'soy un desarrollador de software junior con experiencia en desarrollo web y APIs, utilizando .NET con C#. Estoy familiarizado con el uso de arquitecturas limpias, especialmente el enfoque Onion Architecture. Me considero una persona proactiva, colaborativa y comprometida con la mejora continua, tanto en el ámbito profesional como personal.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de los Desarrolladores'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: desarrolladores.length,
        itemBuilder: (context, index) {
          final desarrollador = desarrolladores[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Foto del desarrollador
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(desarrollador['foto']!),
                  ),
                  SizedBox(height: 10),

                  // Nombre del desarrollador
                  Text(
                    desarrollador['nombre']!,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),

                  // Matrícula
                  Text(
                    'Matrícula: ${desarrollador['matricula']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 10),

                  // Reflexión
                  Text(
                    '"${desarrollador['reflexion']!}"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
