import 'package:evena/models/evento.dart';
import 'package:evena/services/favoritos_service.dart';
import 'package:flutter/material.dart';

class CardEvento extends StatelessWidget {
  final Evento evento;
  final VoidCallback onTap;
  final bool compacto;

  const CardEvento({
    super.key,
    required this.evento,
    required this.onTap,
    this.compacto = false,
  });

  Widget _imagem() {
    if (evento.imagemUrl.startsWith('http://') ||
        evento.imagemUrl.startsWith('https://')) {
      return Image.network(
        evento.imagemUrl,
        width: compacto ? 104 : 126,
        height: compacto ? 112 : 132,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return Image.asset(
      evento.imagemUrl,
      width: compacto ? 104 : 126,
      height: compacto ? 112 : 132,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      width: compacto ? 104 : 126,
      height: compacto ? 112 : 132,
      color: const Color(0xFF251660),
      child: const Icon(Icons.event_rounded, color: Colors.white38, size: 36),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritos = FavoritosService.instance;

    return AnimatedBuilder(
      animation: favoritos,
      builder: (context, _) {
        final favoritado = favoritos.contem(evento.id);

        return Material(
          color: const Color(0xFF140E32),
          borderRadius: BorderRadius.circular(18),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: _imagem(),
                      ),
                      Positioned(
                        top: 7,
                        left: 7,
                        child: Material(
                          color: Colors.black54,
                          shape: const CircleBorder(),
                          child: IconButton(
                            tooltip: favoritado
                                ? 'Remover dos favoritos'
                                : 'Adicionar aos favoritos',
                            onPressed: () async {
                              final sucesso = await favoritos.alternar(
                                evento.id,
                              );

                              if (!sucesso && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Não foi possível atualizar os favoritos.',
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              favoritado
                                  ? Icons.favorite
                                  : Icons.favorite_border_rounded,
                              color: favoritado
                                  ? const Color(0xFF63D13E)
                                  : Colors.white,
                              size: 19,
                            ),
                            constraints: const BoxConstraints.tightFor(
                              width: 36,
                              height: 36,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: compacto ? 112 : 132,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DataBadge(evento: evento),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  evento.titulo,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    height: 1.2,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          _InfoLinha(
                            icon: Icons.access_time_rounded,
                            texto: evento.hora,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: _InfoLinha(
                                  icon: Icons.location_on_outlined,
                                  texto: evento.local,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const CircleAvatar(
                                radius: 14,
                                backgroundColor: Color(0xFF251660),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 11,
                                ),
                              ),
                            ],
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
      },
    );
  }
}

class _DataBadge extends StatelessWidget {
  final Evento evento;

  const _DataBadge({required this.evento});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 39,
      height: 47,
      decoration: BoxDecoration(
        color: const Color(0xFF140B38),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF7C2BDC)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            evento.dia,
            style: const TextStyle(
              color: Color(0xFF9E5BFF),
              fontWeight: FontWeight.w900,
              fontSize: 16,
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            evento.mes,
            style: const TextStyle(
              color: Colors.white54,
              fontWeight: FontWeight.w700,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLinha extends StatelessWidget {
  final IconData icon;
  final String texto;

  const _InfoLinha({required this.icon, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF9A77D5), size: 15),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            texto,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ),
      ],
    );
  }
}
