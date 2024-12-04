import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uasd2024/menu.dart';
import 'package:uasd2024/preferences_helper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Método para realizar el login a través de la API
  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, ingresa usuario y contraseña")),
      );
    } else {
      // Crear el cuerpo de la solicitud
      final body = json.encode({
        "username": username,
        "password": password,
      });

      try {
        // Realizar la solicitud POST
        final response = await http.post(
          Uri.parse('https://uasdapi.ia3x.com/login'),
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        if (response.statusCode == 200) {
          // Si la solicitud fue exitosa
          final Map<String, dynamic> data = json.decode(response.body);

          if (data['success']) {
            // Login exitoso
            String authToken = data['data']['authToken'];

            // Guardar el token de autenticación (si es necesario)
            await PreferencesHelper.saveAuthToken(authToken);

            // Navegar a la pantalla principal
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MenuPrincipalScreen()),
            );
          } else {
            // Si las credenciales son incorrectas
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(data['message'] ?? "Error desconocido")),
            );
          }
        } else {
          // Si la respuesta no fue exitosa
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error al conectar con el servidor")),
          );
        }
      } catch (e) {
        // Manejar errores de red o excepciones
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  // Método para alternar la visibilidad de la contraseña
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login - UASD"),
        backgroundColor:
            Colors.blue, // Asegúrate de usar los colores institucionales
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo UASD
              Image.asset('assets/uasd_logo.png', width: 400, height: 400),
              SizedBox(height: 20),

              // Campo para el nombre de usuario
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Usuario",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Campo para la contraseña
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Botón de Login
              ElevatedButton(
                onPressed: _login,
                child: Text("Iniciar sesión"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: Colors.blue, // Color del botón
                ),
              ),
              SizedBox(height: 20),

              // Enlace para recuperación de contraseña
              TextButton(
                onPressed: () {
                  // Acción para recuperar la contraseña
                  Navigator.pushNamed(context, '/recover-password');
                },
                child: Text(
                  "¿Olvidaste tu contraseña?",
                  style: TextStyle(color: Colors.blue),
                ),
              ),

              // Enlace para la inscripción
              TextButton(
                onPressed: () {
                  // Redirigir a la página de inscripción
                  Navigator.pushNamed(context, '/inscripcion');
                },
                child: Text(
                  "Estudia con Nosotros",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
