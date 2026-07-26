import 'package:flutter/material.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000010),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Botão de voltar branco
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          Center(
          child: Transform.translate(
          offset: const Offset(0, -40),
              child: Image.asset(
                  'assets/images/logo_evena_s_fundo.png',
                  width: 320,
                  fit: BoxFit.contain,
              ),
          ),
          ),

          Center(
              child: Transform.translate(
                offset: const Offset(0, -100),
                    child: const Text(
                      'Tamo fazendo',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
              ),
          ),





          ],
        ),
      ),
    );
  }
}