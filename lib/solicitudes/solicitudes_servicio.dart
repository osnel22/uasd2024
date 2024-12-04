import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uasd2024/solicitudes/tipo_solicitudes.dart';
import 'package:uasd2024/solicitudes/modeloSolicitudes.dart';

class ApiService {
  static const String apiUrlCrearSolicitud =
      'https://uasdapi.ia3x.com/crear_solicitud';

  // Método para crear una solicitud
  Future<void> crearSolicitud(String tipo, String descripcion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      throw Exception("Token no encontrado. Inicia sesión nuevamente.");
    }

    final response = await http.post(
      Uri.parse(apiUrlCrearSolicitud),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'tipo': tipo,
        'descripcion': descripcion,
      }),
    );

    if (response.statusCode == 200) {
      // Respuesta exitosa
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        print('Solicitud creada exitosamente');
      } else {
        throw Exception('Error al crear la solicitud');
      }
    } else {
      throw Exception(
          'Error al crear la solicitud. Código: ${response.statusCode}');
    }
  }

  // URL de la API de tipos de solicitud
  static const String apiUrl = 'https://uasdapi.ia3x.com/tipos_solicitudes';

  // Método para obtener los tipos de solicitud
  Future<List<TipoSolicitud>> fetchTiposSolicitud() async {
    // Obtener el token desde SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    // Verificar si el token está presente
    if (token == null) {
      throw Exception("Token no encontrado. Inicia sesión nuevamente.");
    }

    // Crear los encabezados con el token de autenticación
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token', // Incluye el token en el encabezado
    };

    // Realizar la solicitud GET con los encabezados adecuados
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    // Procesar la respuesta
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((item) => TipoSolicitud.fromJson(item)).toList();
    } else {
      throw Exception(
          'Error al cargar los tipos de solicitud. Código: ${response.statusCode}');
    }
  }

  final String baseUrl = 'https://uasdapi.ia3x.com/mis_solicitudes';

  // Función para obtener las solicitudes
  Future<List<Solicitud>> fetchSolicitudes(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token', // Usar el token proporcionado
      },
    );

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, parseamos los datos JSON
      final data = json.decode(response.body);
      List<Solicitud> solicitudes = [];
      for (var item in data['data']) {
        solicitudes.add(Solicitud.fromJson(
            item)); // Crear un objeto de solicitud a partir de cada elemento
      }
      return solicitudes;
    } else {
      throw Exception('Error al cargar las solicitudes');
    }
  }
}
