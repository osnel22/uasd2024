import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeudaService {
  final String _url = 'https://uasdapi.ia3x.com/deudas';

  // Método para obtener la deuda desde el API utilizando el token guardado en SharedPreferences
  Future<Map<String, dynamic>> obtenerDeuda() async {
    // Obtener el token desde SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      throw Exception("Token no encontrado. Inicia sesión nuevamente.");
    }

    try {
      final response = await http.get(
        Uri.parse(_url),
        headers: {
          'Accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Parsear el JSON y devolver la primera deuda
        final data = json.decode(response.body);
        return data[
            0]; // Suponiendo que la respuesta es una lista y solo tiene un ítem
      } else {
        throw Exception('Error al obtener la deuda');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
