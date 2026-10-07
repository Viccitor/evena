import 'package:evena/components/card_secao.dart';
import 'package:evena/models/evento.dart';
import 'package:flutter/material.dart';

/// Seção "Atrações" da tela de detalhe. Se o evento não tem atrações,
/// não desenha nada.
class SecaoAtracoesEvento extends StatelessWidget {
  final List<Atracao> atracoes;

  const SecaoAtracoesEvento({super.key, required this.atracoes});

  @override
  Widget build(BuildContext context) {
    if (atracoes.isEmpty) return const SizedBox.shrink();

    return CardSecao(
      titulo: 'Atrações',
      icone: Icons.mic_external_on_rounded,
      conteudo: Column(
        children: [
          for (var i = 0; i < atracoes.length; i++) ...[
            _ItemAtracao(atracao: atracoes[i]),
            if (i != atracoes.length - 1)
              const Divider(color: Colors.white12, height: 22),
          ],
        ],
      ),
    );
  }
}

class _ItemAtracao extends StatelessWidget {
  final Atracao atracao;

  const _ItemAtracao({required this.atracao});

  Widget _avatar() {
    final inicial = atracao.nome.trim()[0].toUpperCase();

    final fallback = Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B1E78), Color(0xFF251660)],
        ),
      ),
      child: Text(
        inicial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    );

    final foto = atracao.foto;
    final ehUrl = foto != null &&
        (foto.startsWith('http://') || foto.startsWith('https://'));

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 48,
        height: 48,
        child: ehUrl
            ? Image.network(
          foto,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback,
        )
            : fallback,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _avatar(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                atracao.nome,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (atracao.descricao.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  atracao.descricao,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}