import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Clase Noticia que representa la estructura de una noticia
class Noticia {
  final String id;
  final String title;
  final String img;
  final String url;
  final String date;

  Noticia({
    required this.id,
    required this.title,
    required this.img,
    required this.url,
    required this.date,
  });

  // Método para crear una instancia de Noticia desde JSON
  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'],
      title: json['title'],
      img: json['img'],
      url: json['url'],
      date: json['date'],
    );
  }
}

// Clase NoticiasService que maneja la lógica de obtención de noticias
class NoticiasService {
  final String apiUrl = "https://uasdapi.ia3x.com/noticias";

  // Método para obtener las noticias desde el API
  Future<List<Noticia>> fetchNoticias() async {
    // Obtener el token desde SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      throw Exception("Token no encontrado. Inicia sesión nuevamente.");
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token', // Usa el token dinámicamente
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => Noticia.fromJson(json)).toList();
    } else {
      throw Exception("Error al cargar las noticias");
    }
  }
}

// Pantalla que muestra las noticias
class NoticiasPage extends StatefulWidget {
  @override
  _NoticiasPageState createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  late Future<List<Noticia>> _noticias;

  @override
  void initState() {
    super.initState();
    _noticias = NoticiasService().fetchNoticias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticias UASD 2024'),
      ),
      body: FutureBuilder<List<Noticia>>(
        future: _noticias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay noticias disponibles.'));
          } else {
            final noticias = snapshot.data!;
            return ListView.builder(
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                final noticia = noticias[index];
                return ListTile(
                  leading: Image.network(noticia.img),
                  title: Text(noticia.title),
                  subtitle: Text(noticia.date),
                  onTap: () {
                    // Abre el enlace de la noticia
                    _launchURL(noticia.url);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  // Método para abrir el enlace de la noticia
  void _launchURL(String url) {
    print("Abriendo URL: $url");
  }
}
