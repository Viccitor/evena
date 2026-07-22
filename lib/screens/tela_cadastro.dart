import 'package:flutter/material.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000010), // Mesma cor de fundo do seu app
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Botão de voltar branco
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(
              width: double.infinity,
              child: Image.asset(
                'assets/images/imagem_cadastro.png',
                height: 320,
                fit: BoxFit.cover,
              ),
            ),

            const Center(
            child: Text(
              'Conectando pessoas a experiências inesquecíveis.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, color: Colors.white),
            ),
            ),
            const SizedBox(height: 30),

            // 🚀 AQUI VOCÊ VAI COLOCAR OS INPUTS E BOTÕES DO SEU DESIGN

          ],
        ),
      ),
    );
  }
}