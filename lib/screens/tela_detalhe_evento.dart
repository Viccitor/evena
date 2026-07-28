import 'package:flutter/material.dart';
import 'package:evena/models/evento.dart';

class TelaDetalheEvento extends StatelessWidget {
  final Evento evento;

  const TelaDetalheEvento({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080427),
      appBar: AppBar(
        title: Text(evento.titulo), // Exemplo usando o dado dinâmico
        backgroundColor: const Color(0xFF01011D),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              evento.imagemUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    evento.titulo,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Data: ${evento.dia} de ${evento.mes} às ${evento.hora}',
                    style: const TextStyle(color: Color(0xFF63D13E)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Local: ${evento.local}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    evento.descricao,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}