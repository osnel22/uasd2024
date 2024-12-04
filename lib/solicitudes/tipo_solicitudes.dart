class TipoSolicitud {
  final String codigo;
  final String descripcion;

  TipoSolicitud({
    required this.codigo,
    required this.descripcion,
  });

  // Método para crear un TipoSolicitud desde JSON
  factory TipoSolicitud.fromJson(Map<String, dynamic> json) {
    return TipoSolicitud(
      codigo: json['codigo'],
      descripcion: json['descripcion'],
    );
  }
}
