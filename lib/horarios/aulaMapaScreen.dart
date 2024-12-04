import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart'; // Necesitas agregar esta dependencia para la geocodificación

class AulaMapaScreen extends StatefulWidget {
  final String aula;
  final String ubicacion;

  AulaMapaScreen({required this.aula, required this.ubicacion});

  @override
  _AulaMapaScreenState createState() => _AulaMapaScreenState();
}

class _AulaMapaScreenState extends State<AulaMapaScreen> {
  late GoogleMapController mapController;
  late LatLng _ubicacionLatLng;

  @override
  void initState() {
    super.initState();
    _ubicacionLatLng = LatLng(18.4655, -69.9458); // Coordenada predeterminada
    _getCoordinatesFromAddress(widget.ubicacion);
  }

  // Función para obtener las coordenadas a partir de la dirección
  Future<void> _getCoordinatesFromAddress(String direccion) async {
    try {
      // Usamos el paquete geocoding para obtener las coordenadas
      List<Location> locations = await locationFromAddress(direccion);
      if (locations.isNotEmpty) {
        setState(() {
          _ubicacionLatLng =
              LatLng(locations[0].latitude, locations[0].longitude);
        });
        _moveCameraToLocation();
      }
    } catch (e) {
      print("Error al obtener coordenadas: $e");
    }
  }

  // Función para mover la cámara del mapa a las nuevas coordenadas
  void _moveCameraToLocation() {
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_ubicacionLatLng, 18.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubicación de ${widget.aula}"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _ubicacionLatLng,
          zoom: 18.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId(widget.aula),
            position: _ubicacionLatLng,
            infoWindow: InfoWindow(title: widget.aula),
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          // Mover la cámara al punto después de la inicialización
          _moveCameraToLocation();
        },
      ),
    );
  }
}
