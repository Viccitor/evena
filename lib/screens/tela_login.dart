import 'package:flutter/material.dart';
import 'package:evena/components/campo_texto_customizado.dart';
import 'tela_inicio.dart';
import 'package:evena/components/botao_customizado.dart';
import 'tela_cadastro.dart';
import 'tela_esqueceu_senha.dart';

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
                        text: 'Bem-vindo de ',
                      ),
                      TextSpan(
                        text: 'volta!\n',
                        style: TextStyle(
                          color: Color(0xFF5CD825),
                        ),
                      ),
                      TextSpan(
                        text: 'Faça login para continuar',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25), // Espaçamento entre texto e inputs

              CampoTextoCustomizado(
                titulo: 'E-mail',
                labelText: 'seu@email.com',
                prefixIcon: Icons.mail_outline,
                isSenha: false,
              ),

              const SizedBox(height: 15),

              CampoTextoCustomizado(
                titulo: 'Senha',
                labelText: 'Digite sua senha',
                prefixIcon: Icons.lock_outline,
                isSenha: true,
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TelaEsqueceuSenha()),
                    );
                  },
                  child: const Text(
                    'Esqueceu sua senha?',
                    style: TextStyle(
                      color: Color(0xFF7E22D2),
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF7E22D2),
                    ),
                  ),
                ),
              ),

                SizedBox(height: 30),



              BotaoCustomizado(
                texto: 'Entrar',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TelaInicio()),
                  );
                },
              )



            ],
          ),
        ),
      ),
    );
  }
}