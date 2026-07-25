import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'tela_login.dart';
import 'package:evena/main.dart';


class CampoTextoCustomizado extends StatefulWidget {
  final String titulo;
  final String labelText;
  final IconData prefixIcon;
  final bool isSenha; // 🚀 Define se é um campo de senha (para mostrar o olho)
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const CampoTextoCustomizado({
    super.key,
    required this.titulo,
    required this.labelText,
    required this.prefixIcon,
    this.isSenha = false, // Por padrão não é senha
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  State<CampoTextoCustomizado> createState() => _CampoTextoCustomizadoState();
}

class _CampoTextoCustomizadoState extends State<CampoTextoCustomizado> {
  late bool _esconderTexto;

  @override
  void initState() {
    super.initState();
    _esconderTexto = widget.isSenha;

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          widget.titulo,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        // Campo de Texto
        TextField(
          controller: widget.controller,
          obscureText: _esconderTexto,
          keyboardType: widget.keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: const TextStyle(color: Colors.white38),
            prefixIcon: Icon(widget.prefixIcon),

            // Cor dinâmica do ícone da esquerda
            prefixIconColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.focused)) {
                return const Color(0xFF63D13E);
              }
              return const Color(0XFFA62CFB);
            }),





            suffixIcon: widget.isSenha
                ? IconButton(
              icon: Icon(
                _esconderTexto
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.white70,
              ),
              onPressed: () {
                // Inverte a visibilidade ao clicar no olho
                setState(() {
                  _esconderTexto = !_esconderTexto;
                });
              },
            )
                : null,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF3B1E78)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF63D13E), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}









class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  bool _aceitouTermos = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000010),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),


        body: SingleChildScrollView( // 🚀 1. Coloque o ScrollView por fora
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                  text:'É rápido e fácil!',
                  style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.white70,
                  fontSize: 15,

                  ),

                ),




              ]
            ),
          ),

            SizedBox(height: 30),



            CampoTextoCustomizado(
              titulo: 'Nome',
              labelText: 'Digite seu nome completo',
              prefixIcon: Icons.person_outline,
            ),

            const SizedBox(height: 20),


            CampoTextoCustomizado(
              titulo: 'E-mail',
              labelText: 'seuemail@exemplo.com',
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 20),


            CampoTextoCustomizado(
              titulo: 'Senha',
              labelText: 'Crie uma senha forte',
              prefixIcon: Icons.lock_outline,
              isSenha: true,
            ),

            const SizedBox(height: 20),

            CampoTextoCustomizado(
              titulo: 'Confirmar senha',
              labelText: 'Repita sua senha',
              prefixIcon: Icons.lock_outline,
              isSenha: true,
            ),

    SizedBox(height: 10),




    CheckboxListTile( //termos
      title: RichText(
      text: const TextSpan(
        style: TextStyle(
          height: 1.6,
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),

        children: [

          TextSpan(
            text: 'Eu aceito os ',
          ),

          TextSpan(
            text: ' Termos de Uso',
            style: TextStyle(
              color: Color(0xFF5CD825),
              decoration: TextDecoration.underline,
            ),
          ),

            TextSpan(
              text: ' e a ',
            ),

            TextSpan(
              text: ' Política de Privacidade',
              style: TextStyle(
                color: Color(0xFF5CD825),
                decoration: TextDecoration.underline,
              ),

          ),
        ],
      ),
    ),

      value: _aceitouTermos,
      onChanged: (novoValor) {
        setState(() {
          _aceitouTermos = novoValor ?? false;
        });
      },
        activeColor: const Color(0xFF63D13E),
        checkColor: Colors.black,
        tileColor: Colors.transparent,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
    ),

        SizedBox(height: 10),



                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _aceitouTermos
                        ? () {
                      print('Botão criar conta Clicado');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Evena')),
                      );
                    }
                        : null,

                    style: ElevatedButton.styleFrom(

                      backgroundColor: _aceitouTermos
                          ? const Color(0xFF5CD825)
                          : const Color(0xFF2C2C3E),


                      foregroundColor: _aceitouTermos ? Colors.black : Colors.white38,


                      disabledBackgroundColor: const Color(0xFF1E1E2C),
                      disabledForegroundColor: Colors.white30,

                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),

                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 20),
                        Text(
                          'Criar Conta',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

        const SizedBox(height: 30),

                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        height: 1.6,
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),

                      children: [

                        TextSpan(
                          text: 'Já tem uma conta?',
                        ),

                        TextSpan(

                          text: ' Entrar',
                          style: TextStyle(
                            color: Color(0xFF5CD825),
                            decoration: TextDecoration.underline,
                          ),

                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Usuário clicou em Entrar!');


                               Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TelaLogin()),
                                );
                            },


                        ),
                      ],
                    ),
                  ),
                )






            ],
          ),
        ),
      ),
    );
  }
}