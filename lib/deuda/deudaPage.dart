import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uasd2024/deuda/deuda_service.dart';

class DeudaPage extends StatefulWidget {
  @override
  _DeudaPageState createState() => _DeudaPageState();
}

class _DeudaPageState extends State<DeudaPage> {
  late Future<Map<String, dynamic>> _deuda;

  @override
  void initState() {
    super.initState();
    _loadDeuda();
  }

  // Cargar la deuda utilizando el servicio
  void _loadDeuda() async {
    setState(() {
      _deuda = DeudaService().obtenerDeuda();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Estado de la Deuda"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _deuda,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No se pudo cargar la deuda.'));
          } else {
            final deuda = snapshot.data!;
            return Center(
              // Aquí centramos todo el contenido
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centramos verticalmente
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Centramos horizontalmente
                  children: [
                    Text(
                      'Monto de deuda: \$${deuda['monto']}',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Estado: ${deuda['pagada'] ? 'Pagada' : 'No Pagada'}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Al presionar el botón, redirigimos al usuario al enlace de pago
                        _abrirPaginaDePago();
                      },
                      child: Text('Pagar'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Método para abrir la URL del sistema de pago
  void _abrirPaginaDePago() async {
    const url = 'https://uasd.edu.do/servicios/pago-en-linea/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }
}
