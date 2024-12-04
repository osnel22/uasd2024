import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'modeloSolicitudes.dart';

class MisSolicitudesScreen extends StatefulWidget {
  @override
  _MisSolicitudesScreenState createState() => _MisSolicitudesScreenState();
}

class _MisSolicitudesScreenState extends State<MisSolicitudesScreen> {
  late Future<List<Solicitud>> _solicitudes;

  @override
  void initState() {
    super.initState();
    _solicitudes = _fetchSolicitudes();
  }

  Future<List<Solicitud>> _fetchSolicitudes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      throw Exception("Token no encontrado. Inicia sesión nuevamente.");
    }

    final apiUrl = 'https://uasdapi.ia3x.com/mis_solicitudes'; // URL de la API
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token', // Usar el token dinámicamente
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'] == true) {
        // Extraemos la lista de solicitudes del campo 'data'
        final List<dynamic> data = jsonResponse['data'];
        return data.map((solicitud) => Solicitud.fromJson(solicitud)).toList();
      } else {
        throw Exception('Error en la respuesta: ${jsonResponse['message']}');
      }
    } else {
      throw Exception(
          'Error al obtener las solicitudes: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Solicitudes"),
      ),
      body: FutureBuilder<List<Solicitud>>(
        future: _solicitudes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tienes solicitudes registradas.'));
          } else {
            final solicitudes = snapshot.data!;
            return ListView.builder(
              itemCount: solicitudes.length,
              itemBuilder: (context, index) {
                final solicitud = solicitudes[index];
                return ListTile(
                  title: Text(solicitud.descripcion),
                  subtitle: Text('Estado: ${solicitud.estado}'),
                  isThreeLine: true,
                  onTap: () {
                    // Lógica para ver detalles
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
