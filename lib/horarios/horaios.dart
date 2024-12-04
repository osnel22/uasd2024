import 'package:flutter/material.dart';
import 'horarios_service.dart';
import 'aulaMapaScreen.dart';

class HorariosPage extends StatefulWidget {
  @override
  _PreseleccionesPageState createState() => _PreseleccionesPageState();
}

class _PreseleccionesPageState extends State<HorariosPage> {
  late Future<List<Preseleccion>> _preselecciones;

  @override
  void initState() {
    super.initState();
    _preselecciones = PreseleccionService().fetchPreselecciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Horarios de Materias"),
      ),
      body: FutureBuilder<List<Preseleccion>>(
        future: _preselecciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay preselecciones disponibles.'));
          } else {
            final preselecciones = snapshot.data!;
            return ListView.builder(
              itemCount: preselecciones.length,
              itemBuilder: (context, index) {
                final preseleccion = preselecciones[index];
                return Card(
                  child: ListTile(
                    title: Text(preseleccion.nombre),
                    subtitle: Text(
                      "Aula: ${preseleccion.aula}\nUbicación: ${preseleccion.ubicacion}",
                    ),
                    trailing: Icon(Icons.map),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AulaMapaScreen(
                            aula: preseleccion.aula,
                            ubicacion: preseleccion.ubicacion,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
