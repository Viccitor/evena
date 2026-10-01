import 'package:flutter/material.dart';

class PerfilConquistas extends StatelessWidget {
  final String titulo;
  final String descricao;
  final IconData icone;
  final Color corIcone;
  final VoidCallback? onTap;

  const PerfilConquistas({
    super.key,
    required this.titulo,
    required this.descricao,
    this.icone = Icons.emoji_events,
    this.corIcone = const Color(0xFF63D13E),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF593BA2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                // Ícone conquista
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF593BA2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icone,
                    color: corIcone,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 8),

                // Coluna com Título e Subtítulo
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        descricao,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}