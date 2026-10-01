import 'package:flutter/material.dart';
import 'package:evena/models/evento.dart';

class PerfilFavoritos extends StatelessWidget {
  final Evento evento;
  final VoidCallback onTap;

  const PerfilFavoritos({
    super.key,
    required this.evento,
    required this.onTap,
  });

  Widget _buildImagem() {
    if (evento.imagemUrl.startsWith('http://') ||
        evento.imagemUrl.startsWith('https://')) {
      return Image.network(
        evento.imagemUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return Image.asset(
      evento.imagemUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      color: const Color(0xFF251660),
      child: const Icon(Icons.event_rounded, color: Colors.white38, size: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.transparent, // Fundo transparente
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF593BA2), // Borda restaurada!
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: _buildImagem(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          evento.titulo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.white70,
                              size: 11,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                '${evento.local} - ${evento.hora}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}