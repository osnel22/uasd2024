import 'package:flutter/material.dart';
import 'package:uasd2024/solicitudes/solicitudes_servicio.dart';
import 'package:uasd2024/solicitudes/tipo_solicitudes.dart';

class CrearSolicitudScreen extends StatefulWidget {
  final TipoSolicitud tipoSolicitud;

  CrearSolicitudScreen({required this.tipoSolicitud});

  @override
  _CrearSolicitudScreenState createState() => _CrearSolicitudScreenState();
}

class _CrearSolicitudScreenState extends State<CrearSolicitudScreen> {
  TextEditingController _descripcionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-poblar el campo de descripción con el tipo de solicitud seleccionado
    _descripcionController.text = widget.tipoSolicitud.descripcion;
  }

  // Función para crear la solicitud
  Future<void> _crearSolicitud() async {
    if (_descripcionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Por favor, ingresa una descripción.")));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();
      await apiService.crearSolicitud(
          widget.tipoSolicitud.codigo, _descripcionController.text);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Solicitud creada exitosamente")));
      Navigator.pop(context); // Regresar a la pantalla anterior
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Solicitud: ${widget.tipoSolicitud.descripcion}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Descripción de la solicitud"),
            TextField(
              controller: _descripcionController,
              decoration:
                  InputDecoration(hintText: "Ingresa una descripción..."),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _crearSolicitud,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text("Crear Solicitud"),
            ),
          ],
        ),
      ),
    );
  }
}
