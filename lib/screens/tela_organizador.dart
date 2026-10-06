import 'package:evena/components/botao_customizado.dart';
import 'package:evena/screens/tela_cadastro.dart';
import 'package:evena/screens/tela_criar_evento.dart';
import 'package:evena/screens/tela_login.dart';
import 'package:evena/services/auth_service.dart';
import 'package:flutter/material.dart';

class TelaOrganizador extends StatelessWidget {
  const TelaOrganizador({super.key});

  void _criarEvento(BuildContext context) {
    if (AuthService.estaLogado) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TelaCriarEvento()),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Entre na sua conta para criar um evento.')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaLogin()),
    );
  }

  void _criarContaOrganizador(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaCadastro()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080427),
      appBar: AppBar(
        backgroundColor: const Color(0xFF080427),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF00).withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF00FF00).withValues(alpha: .32),
                  ),
                ),
                child: const Icon(
                  Icons.campaign_rounded,
                  color: Color(0xFF00FF00),
                  size: 28,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Para organizadores',
                style: TextStyle(
                  color: Color(0xFF00FF00),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text.rich(
                TextSpan(
                  text: 'Organize ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                  children: [
                    TextSpan(
                      text: 'seu evento',
                      style: TextStyle(color: Color(0xFF00FF00)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Cadastre sua programação com data, formato, localização ou link online e deixe tudo pronto para aparecer no Evena.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 24),
              const _CardBeneficio(
                icone: Icons.travel_explore_rounded,
                titulo: 'Mais fácil de descobrir',
                descricao:
                    'Seu evento entra na busca e nas categorias da plataforma para o público encontrar.',
              ),
              const SizedBox(height: 12),
              const _CardBeneficio(
                icone: Icons.devices_rounded,
                titulo: 'Presencial ou online',
                descricao:
                    'Informe endereço para eventos presenciais ou o link de acesso quando o evento for online.',
              ),
              const SizedBox(height: 12),
              const _CardBeneficio(
                icone: Icons.photo_camera_back_rounded,
                titulo: 'Divulgação completa',
                descricao:
                    'Adicione capa, descrição, categoria, data e atrações em um fluxo simples de publicação.',
              ),
              const SizedBox(height: 26),
              const Text(
                'Como funciona',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              const _Passo(numero: '1', texto: 'Preencha as informações do evento'),
              const _Passo(numero: '2', texto: 'Revise data, formato e detalhes'),
              const _Passo(numero: '3', texto: 'Publique e acompanhe o evento no app'),
              const SizedBox(height: 28),
              BotaoCustomizado(
                texto: 'Crie seu evento',
                temSeta: true,
                onPressed: () => _criarEvento(context),
              ),
              ValueListenableBuilder(
                valueListenable: AuthService.perfilListenable,
                builder: (context, perfil, _) {
                  if (perfil != null) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: BotaoCustomizado(
                      texto: 'Criar conta',
                      isSecundario: true,
                      onPressed: () => _criarContaOrganizador(context),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardBeneficio extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;

  const _CardBeneficio({
    required this.icone,
    required this.titulo,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF140E32),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2F1A67).withValues(alpha: .9),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF00FF00).withValues(alpha: .10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icone, color: const Color(0xFF00FF00), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  descricao,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Passo extends StatelessWidget {
  final String numero;
  final String texto;

  const _Passo({required this.numero, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFF2F1A67),
              shape: BoxShape.circle,
            ),
            child: Text(
              numero,
              style: const TextStyle(
                color: Color(0xFF00FF00),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
