import 'package:flutter/material.dart';
import 'package:evena/models/evento.dart';

class CardHistoricoEvento extends StatelessWidget {
  final Evento evento;
  final VoidCallback? onTap;

  const CardHistoricoEvento({
    super.key,
    required this.evento,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container( // card de evento
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF593BA2),
              width: 1,
            ),
          ),
          child: Row(
            children: [

              // 1. Bloco da Imagem
              Align(
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(9),
                    bottomLeft: Radius.circular(9),
                  ),
                  child: SizedBox(
                    width: 130,
                    height: 90,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        evento.imagemUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.network(
                          evento.imagemUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // 2. Informações do Evento
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      evento.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${evento.dia} ${evento.mes} • ${evento.hora}', // Data formatada
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF593BA2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        evento.local,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color(0xFFA07AF3),
                          fontSize: 10,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}