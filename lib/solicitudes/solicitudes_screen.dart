import 'package:flutter/material.dart';
import 'package:uasd2024/solicitudes/solicitudes_servicio.dart';
import 'package:uasd2024/solicitudes/tipo_solicitudes.dart';
import 'package:uasd2024/solicitudes/crearSolicitud.dart';
import 'package:uasd2024/solicitudes/misSolicitudes.dart';

class SolicitudesScreen extends StatefulWidget {
  @override
  _SolicitudesScreenState createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen> {
  late ApiService _apiService;
  late Future<List<TipoSolicitud>> _tiposSolicitudes;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _tiposSolicitudes = _apiService.fetchTiposSolicitud();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Solicitudes Administrativas"),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navegar a la pantalla de solicitudes
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MisSolicitudesScreen(), // Nueva pantalla
                ),
              );
            },
            child: Text('Ver estado de tus solicitudes'),
          ),
          Divider(),
          Expanded(
            child: FutureBuilder<List<TipoSolicitud>>(
              future: _tiposSolicitudes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('No hay tipos de solicitudes disponibles.'));
                } else {
                  final tiposSolicitudes = snapshot.data!;
                  return ListView.builder(
                    itemCount: tiposSolicitudes.length,
                    itemBuilder: (context, index) {
                      final tipo = tiposSolicitudes[index];
                      return ListTile(
                        title: Text(tipo.descripcion),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CrearSolicitudScreen(
                                tipoSolicitud: tipo,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
