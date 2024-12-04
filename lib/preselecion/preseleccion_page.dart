import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Modelo para las materias
class Materia {
  final String codigo;
  final String nombre;
  final String horario;
  final String aula;
  final String ubicacion;

  Materia({
    required this.codigo,
    required this.nombre,
    required this.horario,
    required this.aula,
    required this.ubicacion,
  });

  // Método para convertir JSON a un objeto Materia
  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
      codigo: json['codigo'],
      nombre: json['nombre'],
      horario: json['horario'],
      aula: json['aula'],
      ubicacion: json['ubicacion'],
    );
  }
}

// Servicio para interactuar con el API
class MateriasService {
  final String apiUrl = "https://uasdapi.ia3x.com/materias_disponibles";

  // Método para obtener las materias desde el API
  Future<List<Materia>> fetchMaterias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      throw Exception("Token no encontrado. Inicia sesión nuevamente.");
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Materia.fromJson(json)).toList();
    } else {
      throw Exception("Error al cargar las materias disponibles");
    }
  }

  // Método para confirmar la preselección enviando un string al API
  Future<void> confirmarPreseleccion(String materiasSeleccionadas) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      throw Exception("Token no encontrado. Inicia sesión nuevamente.");
    }

    final response = await http.post(
      Uri.parse('https://uasdapi.ia3x.com/preseleccionar_materia'),
      headers: {
        'accept': '*/*',
        'Authorization': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(materiasSeleccionadas),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al confirmar la preselección.");
    }
  }
}

// Pantalla de Preselección
class PreseleccionScreen extends StatefulWidget {
  const PreseleccionScreen({Key? key}) : super(key: key);

  @override
  _PreseleccionScreenState createState() => _PreseleccionScreenState();
}

class _PreseleccionScreenState extends State<PreseleccionScreen> {
  final MateriasService _materiasService = MateriasService();
  List<Materia> _materias = [];
  List<String> _materiasSeleccionadas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarMaterias();
  }

  // Método para cargar las materias
  Future<void> _cargarMaterias() async {
    setState(() {
      _cargando = true;
    });

    try {
      List<Materia> materias = await _materiasService.fetchMaterias();
      setState(() {
        _materias = materias;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  // Método para confirmar la preselección
  Future<void> _confirmarPreseleccion() async {
    if (_materiasSeleccionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debe seleccionar al menos una materia.")),
      );
      return;
    }

    // Convertir la lista de códigos a un string separado por comas
    final materiasString = _materiasSeleccionadas.join(',');

    try {
      await _materiasService.confirmarPreseleccion(materiasString);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preselección confirmada con éxito.")),
      );

      setState(() {
        _materiasSeleccionadas.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preselección de Materias"),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _materias.length,
                    itemBuilder: (context, index) {
                      final materia = _materias[index];
                      final seleccionada =
                          _materiasSeleccionadas.contains(materia.codigo);

                      return ListTile(
                        title: Text(materia.nombre),
                        subtitle: Text("${materia.horario} - ${materia.aula}"),
                        trailing: Checkbox(
                          value: seleccionada,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _materiasSeleccionadas.add(materia.codigo);
                              } else {
                                _materiasSeleccionadas.remove(materia.codigo);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _materiasSeleccionadas.isEmpty
                        ? null
                        : () {
                            _confirmarPreseleccion();
                          },
                    child: const Text("Confirmar Preselección"),
                  ),
                ),
              ],
            ),
    );
  }
}
