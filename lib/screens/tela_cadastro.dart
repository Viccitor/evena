import 'package:evena/components/botao_customizado.dart';
import 'package:evena/components/campo_texto_customizado.dart';
import 'package:evena/main.dart';
import 'package:evena/services/auth_service.dart';
import 'package:evena/services/favoritos_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'tela_login.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  bool _aceitouTermos = false;
  bool _nomeAlterado = false;
  bool _emailAlterado = false;
  bool _senhaAlterada = false;
  bool _confirmacaoAlterada = false;
  bool _carregando = false;

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  String? get _erroNome {
    if (!_nomeAlterado) {
      return null;
    }

    return _nomeController.text.trim().isEmpty ? 'Digite seu nome.' : null;
  }

  String? get _erroEmail {
    if (!_emailAlterado) {
      return null;
    }

    return AuthService.validarEmail(_emailController.text);
  }

  String? get _erroSenha {
    if (!_senhaAlterada) {
      return null;
    }

    return AuthService.validarSenha(_senhaController.text);
  }

  String? get _erroConfirmacao {
    if (!_confirmacaoAlterada) {
      return null;
    }

    if (_confirmarSenhaController.text.isEmpty) {
      return 'Repita sua senha.';
    }

    if (_senhaController.text != _confirmarSenhaController.text) {
      return 'As senhas não são iguais.';
    }

    return null;
  }

  bool get _formularioValido {
    return _nomeController.text.trim().isNotEmpty &&
        AuthService.validarEmail(_emailController.text) == null &&
        AuthService.validarSenha(_senhaController.text) == null &&
        _senhaController.text == _confirmarSenhaController.text &&
        _confirmarSenhaController.text.isNotEmpty &&
        _aceitouTermos;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _criarConta() async {
    setState(() {
      _nomeAlterado = true;
      _emailAlterado = true;
      _senhaAlterada = true;
      _confirmacaoAlterada = true;
    });

    if (!_formularioValido || _carregando) {
      return;
    }

    setState(() => _carregando = true);

    final erro = await AuthService.cadastrar(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
    );

    if (!mounted) {
      return;
    }

    setState(() => _carregando = false);

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro)));
      return;
    }

    await FavoritosService.instance.carregar();

    if (!mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Evena')),
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
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    height: 1.6,
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(text: 'Crie sua '),
                    TextSpan(
                      text: 'conta\n',
                      style: TextStyle(
                        color: Color(0xFF63D13E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: 'É rápido e fácil!',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              CampoTextoCustomizado(
                titulo: 'Nome',
                labelText: 'Digite seu nome completo',
                prefixIcon: Icons.person_outline,
                controller: _nomeController,
                errorText: _erroNome,
                onChanged: (_) {
                  setState(() {
                    _nomeAlterado = true;
                  });
                },
              ),
              const SizedBox(height: 20),
              CampoTextoCustomizado(
                titulo: 'E-mail',
                labelText: 'seuemail@exemplo.com',
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
              const SizedBox(height: 20),
              CampoTextoCustomizado(
                titulo: 'Senha',
                labelText: 'Mín. 8, maiúscula, minúscula e número',
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
              const SizedBox(height: 20),
              CampoTextoCustomizado(
                titulo: 'Confirmar senha',
                labelText: 'Repita sua senha',
                prefixIcon: Icons.lock_outline,
                isSenha: true,
                controller: _confirmarSenhaController,
                errorText: _erroConfirmacao,
                onChanged: (_) {
                  setState(() {
                    _confirmacaoAlterada = true;
                  });
                },
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      height: 1.6,
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(text: 'Eu aceito os '),
                      TextSpan(
                        text: 'Termos de Uso',
                        style: TextStyle(
                          color: Color(0xFF5CD825),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: ' e a '),
                      TextSpan(
                        text: 'Política de Privacidade',
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
              const SizedBox(height: 10),
              BotaoCustomizado(
                texto: _carregando ? 'Criando...' : 'Criar Conta',
                onPressed: _formularioValido && !_carregando
                    ? _criarConta
                    : null,
              ),
              const SizedBox(height: 30),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      height: 1.6,
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      const TextSpan(text: 'Já tem uma conta?'),
                      TextSpan(
                        text: ' Entrar',
                        style: const TextStyle(
                          color: Color(0xFF5CD825),
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TelaLogin(),
                              ),
                            );
                          },
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
