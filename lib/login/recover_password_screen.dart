import 'package:flutter/material.dart';

class RecoverPasswordScreen extends StatelessWidget {
  final _emailController = TextEditingController();

  void _recoverPassword(BuildContext context) {
    String email = _emailController.text;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, ingresa tu correo")),
      );
    } else {
      // Aquí agregar lógica para enviar un enlace de recuperación de contraseña
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Te hemos enviado un enlace para recuperar tu contraseña")),
      );
      Navigator.pop(context); // Regresar al login después de enviar el enlace
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recuperación de Contraseña")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Correo Electrónico",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  _recoverPassword(context), // Pasamos el context aquí
              child: Text("Enviar enlace de recuperación"),
            ),
          ],
        ),
      ),
    );
  }
}
