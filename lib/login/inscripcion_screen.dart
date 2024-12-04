import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InscripcionScreen extends StatelessWidget {
  void _openInscriptionPage() async {
    const url =
        'https://www.uasd.edu.do/inscripcion'; // Reemplaza con el enlace real
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir el enlace';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inscripción - UASD")),
      body: Center(
        child: ElevatedButton(
          onPressed: _openInscriptionPage,
          child: Text("Ir a la página de inscripción"),
        ),
      ),
    );
  }
}
