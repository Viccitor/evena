import 'package:evena/components/botao_customizado.dart';
import 'package:evena/screens/tela_cadastro.dart';
import 'package:evena/screens/tela_criar_evento.dart';
import 'package:evena/screens/tela_login.dart';
import 'package:evena/services/auth_service.dart';
import 'package:flutter/material.dart';

/// Tela de apresentação para organizadores. É o caminho do botão
/// "Criar evento" do drawer até o assistente de criação.
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
    // Por enquanto usa o cadastro normal: ainda não existe um cadastro
    // específico de organizador na API.
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
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Para Organizadores',
                style: TextStyle(
                  color: Color(0xFF63D13E),
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
                      style: TextStyle(color: Color(0xFF63D13E)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Crie a divulgação dos seus próprios eventos e acompanhe '
                    'visualizações, cliques em “Eu Vou” e favoritos em um painel '
                    'de métricas próprio.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              const _CardBeneficio(
                titulo: 'Alcance nacional',
                descricao: 'Seu evento aparece no mapa e nos filtros de quem '
                    'está buscando na sua região.',
              ),
              const SizedBox(height: 12),
              const _CardBeneficio(
                titulo: 'Selo de verificação',
                descricao: 'Empresas com CNPJ validado recebem selo e ganham '
                    'prioridade na listagem.',
              ),
              const SizedBox(height: 28),
              BotaoCustomizado(
                texto: 'Crie seu evento',
                temSeta: true,
                onPressed: () => _criarEvento(context),
              ),
              // Quem já está logado não precisa criar conta de novo.
              ValueListenableBuilder(
                valueListenable: AuthService.perfilListenable,
                builder: (context, perfil, _) {
                  if (perfil != null) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: BotaoCustomizado(
                      texto: 'Crie sua conta de organizador',
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
  final String titulo;
  final String descricao;

  const _CardBeneficio({required this.titulo, required this.descricao});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF140E32),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF7C2BDC).withValues(alpha: .28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 3,
            decoration: BoxDecoration(
              color: const Color(0xFF63D13E),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            descricao,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}