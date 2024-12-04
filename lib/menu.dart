import 'package:flutter/material.dart';

class MenuPrincipalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Opciones del Menú
          ListTile(
            leading: Icon(Icons.newspaper),
            title: Text('Noticias'),
            onTap: () {
              // Acción para Noticias
              Navigator.pushNamed(context, '/noticias');
            },
          ),
          ListTile(
            leading: Icon(Icons.schedule),
            title: Text('Horarios (Mis Materias)'),
            onTap: () {
              // Acción para Horarios
              Navigator.pushNamed(context, '/horarios');
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Preselección'),
            onTap: () {
              // Acción para Preselección
              Navigator.pushNamed(context, '/preseleccion');
            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text('Deuda'),
            onTap: () {
              // Acción para Deuda
              Navigator.pushNamed(context, '/deuda');
            },
          ),
          ListTile(
            leading: Icon(Icons.request_page),
            title: Text('Solicitudes'),
            onTap: () {
              // Acción para Solicitudes
              Navigator.pushNamed(context, '/solicitudes');
            },
          ),
          ListTile(
            leading: Icon(Icons.task),
            title: Text('Mis Tareas'),
            onTap: () {
              // Acción para Mis Tareas
              Navigator.pushNamed(context, '/tareas');
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Eventos'),
            onTap: () {
              // Acción para Eventos
              Navigator.pushNamed(context, '/eventos');
            },
          ),
          ListTile(
            leading: Icon(Icons.video_collection),
            title: Text('Videos'),
            onTap: () {
              // Acción para Videos
              Navigator.pushNamed(context, '/videos');
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Acerca de'),
            onTap: () {
              // Acción para Acerca de
              Navigator.pushNamed(context, '/acerca-de');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Salir'),
            onTap: () {
              // Acción para cerrar sesión
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
