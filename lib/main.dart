import 'package:flutter/material.dart';
import 'package:uasd2024/pantalla_iniciar.dart';
import 'package:uasd2024/login/login.dart';
import 'package:uasd2024/menu.dart';
import 'package:uasd2024/noticias.dart';
import 'package:uasd2024/horarios/horaios.dart';
import 'package:uasd2024/login/inscripcion_screen.dart';
import 'package:uasd2024/login/recover_password_screen.dart';
import 'package:uasd2024/preselecion/preseleccion_page.dart';
import 'package:uasd2024/solicitudes/solicitudes_screen.dart';
import 'package:uasd2024/deuda/deudapage.dart';
import 'package:uasd2024/eventos.dart';
import 'package:uasd2024/acerca_de.dart';
import 'package:uasd2024/videos.dart';
import 'package:uasd2024/tareas.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UASD App',
      initialRoute: '/',
      routes: {
        '/': (context) => LandingScreen(),
        '/login': (context) => LoginScreen(),
        '/menu': (context) => MenuPrincipalScreen(),
        '/noticias': (context) => NoticiasPage(),
        '/recover-password': (context) => RecoverPasswordScreen(),
        '/inscripcion': (context) => InscripcionScreen(),
        '/horarios': (context) => HorariosPage(),
        '/preseleccion': (context) => PreseleccionScreen(),
        '/deuda': (context) => DeudaPage(),
        '/eventos': (context) => EventosScreen(),
        '/acerca-de': (context) => AcercaDePage(),
        '/videos': (context) => VideosScreen(),
        '/tareas': (context) => TareasScreen(),
        '/solicitudes': (context) => SolicitudesScreen()
      },
    );
  }
}
