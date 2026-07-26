import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'tela_login.dart';
import 'package:evena/main.dart';
import 'package:evena/components/campo_texto_customizado.dart';
import 'package:evena/components/botao_customizado.dart';











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


        body: SingleChildScrollView(
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



                BotaoCustomizado(
                  texto: 'Criar Conta',
                  onPressed: _aceitouTermos
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(title: 'Evena'),
                      ),
                    );
                  }
                      : null, // Se for null, o Flutter desabilita o botão e aplica a cor cinza sozinho!
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