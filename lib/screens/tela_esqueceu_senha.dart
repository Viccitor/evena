import 'package:flutter/material.dart';



class TelaEsqueceuSenha extends StatefulWidget {
  const TelaEsqueceuSenha({super.key});

  @override
  State<TelaEsqueceuSenha> createState() => _TelaEsqueceuSenhaState();
}

class _TelaEsqueceuSenhaState extends State<TelaEsqueceuSenha> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000010),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Center(
                child: SizedBox(
                  height: 170,
                  child: OverflowBox(
                    maxHeight: 400,
                    maxWidth: 400,
                    child: Image.asset(
                      'assets/images/logo_evena_s_fundo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Texto Centralizado
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: 'Bem-vindo a ',
                      ),
                      TextSpan(
                        text: 'TAMO FAZENDO!\n',
                        style: TextStyle(
                          color: Color(0xFF5CD825),
                        ),
                      ),
                    ],
                  ),
                ),
              ),





            ],
          ),
        ),
      ),
    );
  }
}