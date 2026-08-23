import'package:evena/components/botao_customizado.dart';
import 'package:evena/components/campo_texto_customizado.dart';
import 'package:evena/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:evena/screens/tela_cadastro.dart';
import 'package:evena/screens/tela_home.dart';
import 'tela_esqueceu_senha.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

Widget _buildBotaoSocial({
  required String caminhoImagem,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16.0),
    child: Container(
      width: 60,
      height: 60,
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: Image.asset(caminhoImagem, fit: BoxFit.contain),
    ),
  );
}

class _TelaLoginState extends State<TelaLogin> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _emailAlterado = false;
  bool _senhaAlterada = false;

  String? get _erroEmail {
    if (!_emailAlterado) return null;
    return AuthService.validarEmailDeLogin(_emailController.text);
  }

  String? get _erroSenha {
    if (!_senhaAlterada) return null;

    final erroEmail = AuthService.validarEmailDeLogin(_emailController.text);
    if (erroEmail != null) return null;

    return AuthService.validarSenhaDeLogin(
      _emailController.text,
      _senhaController.text,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _entrar() {
    setState(() {
      _emailAlterado = true;
      _senhaAlterada = true;
    });

    final erro = AuthService.entrar(
      email: _emailController.text,
      senha: _senhaController.text,
    );

    if (erro != null) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TelaHome()),
      (route) => false,
    );
  }

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
                      TextSpan(text: 'Bem-vindo de '),
                      TextSpan(
                        text: 'volta!\n',
                        style: TextStyle(color: Color(0xFF5CD825)),
                      ),
                      TextSpan(
                        text: 'Fa\u00e7a login para continuar',
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
              const SizedBox(height: 25),
              CampoTextoCustomizado(
                titulo: 'E-mail',
                labelText: 'seu@email.com',
                prefixIcon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                errorText: _erroEmail,
                onChanged: (_) {
                  setState(() {
                    _emailAlterado = true;
                  });
                },
              ),
              const SizedBox(height: 15),
              CampoTextoCustomizado(
                titulo: 'Senha',
                labelText: 'Digite sua senha',
                prefixIcon: Icons.lock_outline,
                isSenha: true,
                controller: _senhaController,
                errorText: _erroSenha,
                onChanged: (_) {
                  setState(() {
                    _senhaAlterada = true;
                  });
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TelaEsqueceuSenha(),
                      ),
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
              const SizedBox(height: 30),
              BotaoCustomizado(texto: 'Entrar', onPressed: _entrar),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.white24, thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'ou continue com',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.white24, thickness: 1)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBotaoSocial(
                    caminhoImagem: 'assets/images/apple_logo_s_fundo.png',
                    onTap: () {},
                  ),
                  _buildBotaoSocial(
                    caminhoImagem: 'assets/images/google_logo_s_fundo.png',
                    onTap: () {},
                  ),
                  _buildBotaoSocial(
                    caminhoImagem: 'assets/images/facebook_logo_s_fundo.png',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TelaCadastro()),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF63D13E),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Não tem uma conta? ',
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextSpan(
                          text: 'Cadastre-se!',
                          style: TextStyle(
                            color: Color(0xFF63D13E),
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
