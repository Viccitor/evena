import 'package:evena/components/botao_customizado.dart';
import 'package:evena/components/campo_texto_customizado.dart';
import 'package:evena/services/auth_service.dart';
import 'package:flutter/material.dart';

class TelaEsqueceuSenha extends StatefulWidget {
  const TelaEsqueceuSenha({super.key});

  @override
  State<TelaEsqueceuSenha> createState() => _TelaEsqueceuSenhaState();
}

class _TelaEsqueceuSenhaState extends State<TelaEsqueceuSenha> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarController = TextEditingController();

  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  Future<void> _alterarSenha() async {
    final erroEmail = AuthService.validarEmail(_emailController.text);
    final erroSenha = AuthService.validarSenha(_senhaController.text);

    if (erroEmail != null) {
      _mensagem(erroEmail);
      return;
    }

    if (erroSenha != null) {
      _mensagem(erroSenha);
      return;
    }

    if (_senhaController.text != _confirmarController.text) {
      _mensagem('As senhas não são iguais.');
      return;
    }

    setState(() => _carregando = true);

    final erro = await AuthService.recuperarSenha(
      email: _emailController.text,
      novaSenha: _senhaController.text,
    );

    if (!mounted) {
      return;
    }

    setState(() => _carregando = false);

    if (erro != null) {
      _mensagem(erro);
      return;
    }

    _mensagem('Senha alterada com sucesso.');

    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo_evena_s_fundo.png',
                height: 150,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Recuperar senha',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Informe seu e-mail e escolha uma nova senha.',
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 28),
            CampoTextoCustomizado(
              titulo: 'E-mail',
              labelText: 'seu@email.com',
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            const SizedBox(height: 18),
            CampoTextoCustomizado(
              titulo: 'Nova senha',
              labelText: 'Mín. 8, maiúscula, minúscula e número',
              prefixIcon: Icons.lock_outline,
              isSenha: true,
              controller: _senhaController,
            ),
            const SizedBox(height: 18),
            CampoTextoCustomizado(
              titulo: 'Confirmar nova senha',
              labelText: 'Repita a nova senha',
              prefixIcon: Icons.lock_outline,
              isSenha: true,
              controller: _confirmarController,
            ),
            const SizedBox(height: 28),
            BotaoCustomizado(
              texto: _carregando ? 'Alterando...' : 'Alterar senha',
              onPressed: _carregando ? null : _alterarSenha,
            ),
          ],
        ),
      ),
    );
  }
}
