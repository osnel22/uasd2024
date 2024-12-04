import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TareasScreen extends StatefulWidget {
  @override
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  List<dynamic> tareas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTareas();
  }

  Future<void> fetchTareas() async {
    final url = Uri.parse('https://uasdapi.ia3x.com/tareas');

    try {
      // Obtener el token desde SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      if (token == null) {
        throw Exception("Token no encontrado. Por favor, inicia sesión.");
      }

      final response = await http.get(
        url,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token', // Usa el token dinámicamente
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          tareas = json.decode(response.body);
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error al obtener las tareas: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error: $e')),
      );
    }
  }

  Future<void> openLink() async {
    const url = 'https://plataformavirtual.itla.edu.do/login/index.php';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir el enlace: $url';
    }
  }

  String formatDate(String fechaString) {
    DateTime fecha = DateTime.parse(fechaString);
    return DateFormat('dd/MM/yyyy - hh:mm a').format(fecha);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas App'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: tareas.length,
              itemBuilder: (context, index) {
                final tarea = tareas[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Sección superior con título
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.send, color: Colors.white, size: 32),
                            SizedBox(height: 8),
                            Text(
                              tarea['titulo'] ?? 'Sin título',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Descripción de la tarea
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              tarea['descripcion'] ?? 'Sin descripción',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 16),
                            // Mostrar fecha de vencimiento
                            Text(
                              'Fecha de vencimiento: ${formatDate(tarea['fechaVencimiento'] ?? 'No especificada')}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Botón para redirigir
                      ElevatedButton(
                        onPressed: openLink,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        child: Text('Ir a Plataforma Virtual'),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
