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
      backgroundColor: const Color(0xFF000010),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),


      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),

          RichText(
            text: const TextSpan(
              style: TextStyle(
                height: 1.6,
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: 'Crie sua ',
                ),
                TextSpan(
                  text: 'conta\n',
                  style: TextStyle(
                    color:Color(0xFF63D13E),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                TextSpan(
                  text: ''
                ),

                TextSpan(
                  text:'É rápido e fácil!',
                  style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.white70,
                  fontSize: 15,

                  ),

                ),
              ]
            ),
          )


            // 🚀 AQUI ABAIXO VOCÊ PODE COLOCAR OS CAMPOS DE TEXTO (EMAIL, SENHA, ETC)
          ],
        ),
      ),
    );
  }
}