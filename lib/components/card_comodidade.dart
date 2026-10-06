import 'package:flutter/material.dart';

/// Uma comodidade/facilidade que um evento pode oferecer.
/// [chave] é o identificador salvo no banco (ex.: 'acessibilidade').
class Comodidade {
  final String chave;
  final String titulo;
  final IconData icone;

  const Comodidade({
    required this.chave,
    required this.titulo,
    required this.icone,
  });
}

/// Catálogo com TODAS as comodidades possíveis.
/// A tela de criar evento pode usar esta mesma lista para montar as opções
/// que o organizador marca, e salvar só as chaves marcadas.
const List<Comodidade> comodidadesCatalogo = [
  Comodidade(
    chave: 'acessibilidade',
    titulo: 'Acessibilidade',
    icone: Icons.accessible_rounded,
  ),
  Comodidade(
    chave: 'estacionamento',
    titulo: 'Estacionamento',
    icone: Icons.local_parking_rounded,
  ),
  Comodidade(
    chave: 'wifi',
    titulo: 'Wi-Fi',
    icone: Icons.wifi_rounded,
  ),
  Comodidade(
    chave: 'alimentacao',
    titulo: 'Alimentação',
    icone: Icons.restaurant_rounded,
  ),
  Comodidade(
    chave: 'banheiros',
    titulo: 'Banheiros',
    icone: Icons.wc_rounded,
  ),
  Comodidade(
    chave: 'seguranca',
    titulo: 'Segurança',
    icone: Icons.security_rounded,
  ),
  Comodidade(
    chave: 'pet_friendly',
    titulo: 'Pet friendly',
    icone: Icons.pets_rounded,
  ),
  Comodidade(
    chave: 'espaco_kids',
    titulo: 'Espaço kids',
    icone: Icons.child_friendly_rounded,
  ),
  Comodidade(
    chave: 'guarda_volumes',
    titulo: 'Guarda-volumes',
    icone: Icons.luggage_rounded,
  ),
  Comodidade(
    chave: 'ar_condicionado',
    titulo: 'Ar-condicionado',
    icone: Icons.ac_unit_rounded,
  ),
];

/// Grade de comodidades, 2 por linha.
/// Mostra todas do catálogo: acesas se estiverem em [ativas], apagadas se não.
class GradeComodidades extends StatelessWidget {
  final List<String> ativas;
  final double espaco;

  const GradeComodidades({
    super.key,
    required this.ativas,
    this.espaco = 10,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final larguraItem = (constraints.maxWidth - espaco) / 2;

        return Wrap(
          spacing: espaco,
          runSpacing: espaco,
          children: comodidadesCatalogo.map((comodidade) {
            return SizedBox(
              width: larguraItem,
              child: CardComodidade(
                titulo: comodidade.titulo,
                icone: comodidade.icone,
                disponivel: ativas.contains(comodidade.chave),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

/// Quadradinho de uma comodidade: título, ícone e status.
/// Aceso (verde) quando [disponivel], apagado (cinza) quando não.
class CardComodidade extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final bool disponivel;

  const CardComodidade({
    super.key,
    required this.titulo,
    required this.icone,
    required this.disponivel,
  });

  static const _verde = Color(0xFF63D13E);

  @override
  Widget build(BuildContext context) {
    final corIcone = disponivel ? _verde : Colors.white24;
    final corTitulo = disponivel ? Colors.white : Colors.white38;
    final corStatus = disponivel ? _verde : Colors.white30;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: disponivel ? const Color(0xFF140E32) : const Color(0xFF0C0821),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: disponivel
              ? _verde.withValues(alpha: .55)
              : Colors.white12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: disponivel
                  ? _verde.withValues(alpha: .14)
                  : Colors.white.withValues(alpha: .04),
            ),
            child: Icon(icone, color: corIcone, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            titulo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: corTitulo,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            disponivel ? 'Disponível' : 'Não disponível',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: corStatus,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}