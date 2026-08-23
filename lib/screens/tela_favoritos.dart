import 'package:flutter/material.dart';
import 'package:evena/models/evento.dart';
import 'package:evena/data/eventos_data.dart';
import 'package:evena/components/card_evento.dart';
import 'package:evena/services/favoritos_service.dart';

class FavoritosTab extends StatelessWidget {
  final ValueChanged<Evento> onAbrirEvento;

  const FavoritosTab({super.key, required this.onAbrirEvento});

  @override
  Widget build(BuildContext context) {
    final favoritos = FavoritosService.instance;

    return AnimatedBuilder(
      animation: favoritos,
      builder: (context, _) {
        final lista = eventos
            .where((evento) => favoritos.contem(evento.id))
            .toList();

        if (lista.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(34),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.white24,
                    size: 68,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum favorito ainda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Toque no coração de um evento e ele aparecerá aqui.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, height: 1.4),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          itemCount: lista.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final evento = lista[index];
            return CardEvento(
              evento: evento,
              compacto: true,
              onTap: () => onAbrirEvento(evento),
            );
          },
        );
      },
    );
  }
}