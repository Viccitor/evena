import 'package:flutter/material.dart';

class CardSecao extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final Widget conteudo;
  final bool expansivel;
  final bool expandido;
  final VoidCallback? onToggle;

  const CardSecao({
    super.key,
    required this.titulo,
    required this.icone,
    required this.conteudo,
    this.expansivel = false,
    this.expandido = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF140E32),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: const Color(0xFF7C2BDC).withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho
          InkWell(
            onTap: expansivel ? onToggle : null,
            borderRadius: BorderRadius.circular(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icone, color: const Color(0xFF8540C6), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (expansivel)
                  Icon(
                    expandido
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF8540C6),
                    size: 20,
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          conteudo,
        ],
      ),
    );
  }
}