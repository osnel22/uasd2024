import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideosScreen extends StatefulWidget {
  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  List<dynamic> videos = [];
  late YoutubePlayerController _playerController;

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      // Recuperar el token desde SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      if (token == null) {
        throw Exception(
            "Token no encontrado. Por favor, inicia sesión nuevamente.");
      }

      final response = await http.get(
        Uri.parse('https://uasdapi.ia3x.com/videos'),
        headers: {
          'Authorization': 'Bearer $token', // Usa el token recuperado
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          videos = json.decode(response.body);
        });
      } else {
        throw Exception('Error al cargar los videos: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void playVideo(String videoId) {
    _playerController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Container(
          height: 300,
          child: YoutubePlayer(
            controller: _playerController,
            showVideoProgressIndicator: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _playerController.dispose();
              Navigator.of(context).pop();
            },
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos UASD'),
        backgroundColor: Colors.blue,
      ),
      body: videos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.video_library, color: Colors.blue),
                    title: Text(
                      video['titulo'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'Publicado el: ${video['fechaPublicacion'].substring(0, 10)}'),
                    onTap: () => playVideo(video['url']),
                  ),
                );
              },
            ),
    );
  }
}
