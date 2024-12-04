import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Modelo para representar los datos de las materias preseleccionadas
class Preseleccion {
  final String codigo;
  final String nombre;
  final String aula;
  final String ubicacion;
  final bool confirmada;

  Preseleccion({
    required this.codigo,
    required this.nombre,
    required this.aula,
    required this.ubicacion,
    required this.confirmada,
  });

  // Método para convertir JSON a un objeto Preseleccion
  factory Preseleccion.fromJson(Map<String, dynamic> json) {
    return Preseleccion(
      codigo: json['codigo'],
      nombre: json['nombre'],
      aula: json['aula'],
      ubicacion: json['ubicacion'],
      confirmada: json['confirmada'],
    );
  }
}

// Servicio para interactuar con el API de preselecciones
class PreseleccionService {
  final String apiUrl = "https://uasdapi.ia3x.com/ver_preseleccion";

  // Método para obtener el token de autenticación desde SharedPreferences
  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // Método para obtener las preselecciones desde el API
  Future<List<Preseleccion>> fetchPreselecciones() async {
    final token = await _getAuthToken();
    if (token == null) {
      throw Exception("Token no encontrado. Inicia sesión nuevamente.");
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'accept': '*/*',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Validar que la respuesta tiene éxito y contiene datos
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> data = responseData['data'];
        return data.map((json) => Preseleccion.fromJson(json)).toList();
      } else {
        throw Exception(
            "Error al cargar las preselecciones: ${responseData['message']}");
      }
    } else {
      throw Exception("Error de red: ${response.statusCode}");
    }
  }
}
