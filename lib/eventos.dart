import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EventosScreen extends StatefulWidget {
  @override
  _EventosScreenState createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  List<dynamic> eventos = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchEventos();
  }

  Future<void> fetchEventos() async {
    setState(() {
      isLoading = true;
    });

    const url = 'https://uasdapi.ia3x.com/eventos';

    try {
      // Recuperar el token desde SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      if (token == null) {
        throw Exception(
            "Token no encontrado. Por favor, inicia sesión nuevamente.");
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token', 'accept': '*/*'},
      );

      if (response.statusCode == 200) {
        setState(() {
          eventos = json.decode(response.body);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatearFecha(String fechaISO) {
    try {
      final fecha = DateTime.parse(fechaISO);
      return DateFormat('dd/MM/yyyy - hh:mm a').format(fecha);
    } catch (e) {
      return 'Fecha inválida';
    }
  }

  void mostrarDetalles(BuildContext context, Map<String, dynamic> evento) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(evento['titulo'] ?? 'Evento'),
          content: Text(
            'Descripción: ${evento['descripcion'] ?? 'Sin descripción'}\n'
            'Lugar: ${evento['lugar'] ?? 'Sin lugar'}\n'
            'Fecha: ${formatearFecha(evento['fechaEvento'] ?? '')}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Eventos')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                final evento = eventos[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(evento['titulo'] ?? 'Sin título'),
                    onTap: () => mostrarDetalles(context, evento),
                  ),
                );
              },
            ),
    );
  }
}
