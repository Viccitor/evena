import 'package:evena/models/evento.dart';
import 'package:evena/services/favoritos_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TelaDetalheEvento extends StatelessWidget {
  final Evento evento;

  const TelaDetalheEvento({super.key, required this.evento});

  String _dois(int valor) => valor.toString().padLeft(2, '0');

  String _dataGoogle(DateTime data) {
    return '${data.year}${_dois(data.month)}${_dois(data.day)}T${_dois(data.hour)}${_dois(data.minute)}${_dois(data.second)}';
  }

  Future<void> _abrirGoogleMaps(BuildContext context) async {
    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': evento.endereco,
    });

    await _abrirUrl(context, uri, 'Não foi possível abrir o Google Maps.');
  }

  Future<void> _abrirGoogleCalendar(BuildContext context) async {
    final uri = Uri.https('calendar.google.com', '/calendar/render', {
      'action': 'TEMPLATE',
      'text': evento.titulo,
      'dates': '${_dataGoogle(evento.inicio)}/${_dataGoogle(evento.fim)}',
      'details': evento.descricao,
      'location': '${evento.local} - ${evento.endereco}',
    });

    await _abrirUrl(
      context,
      uri,
      'Não foi possível abrir o Google Calendar.',
    );
  }

  Future<void> _abrirUrl(BuildContext context, Uri uri, String erro) async {
    final abriu = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!abriu && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro)));
    }
  }

  Widget _imagem() {
    if (evento.imagemUrl.startsWith('http://') ||
        evento.imagemUrl.startsWith('https://')) {
      return Image.network(
        evento.imagemUrl,
        width: double.infinity,
        height: 235,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackImagem(),
      );
    }

    return Image.asset(
      evento.imagemUrl,
      width: double.infinity,
      height: 235,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallbackImagem(),
    );
  }

  Widget _fallbackImagem() {
    return Container(
      width: double.infinity,
      height: 235,
      color: const Color(0xFF251660),
      child: const Icon(Icons.event_rounded, color: Colors.white38, size: 58),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritos = FavoritosService.instance;

    return Scaffold(
      backgroundColor: const Color(0xFF080427),
      appBar: AppBar(
        backgroundColor: const Color(0xFF01011D),
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: Image.asset('assets/images/logo_evena_s_fundo.png', height: 82),
        actions: [
          AnimatedBuilder(
            animation: favoritos,
            builder: (context, _) {
              final favoritado = favoritos.contem(evento.id);

              return IconButton(
                tooltip: favoritado ? 'Remover dos favoritos' : 'Favoritar',
                onPressed: () async {
                  final sucesso = await favoritos.alternar(evento.id);

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
                  favoritado ? Icons.favorite : Icons.favorite_border_rounded,
                  color: favoritado ? const Color(0xFF63D13E) : Colors.white,
                ),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  _imagem(),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: .86),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF63D13E),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            evento.categoria,
                            style: const TextStyle(
                              color: Color(0xFF071008),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          evento.titulo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            height: 1.08,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _CardInfo(
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_rounded,
                    color: Color(0xFF63D13E),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${evento.dia} ${evento.mes} • ${evento.hora}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Adicione para não esquecer',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _abrirGoogleCalendar(context),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Agenda'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF63D13E),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Sobre o evento',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              evento.descricao,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Informações',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MiniInfo(
                    icon: Icons.event_seat_outlined,
                    titulo: 'FORMATO',
                    valor: evento.formato,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MiniInfo(
                    icon: Icons.people_outline,
                    titulo: 'IDADE',
                    valor: evento.classificacao,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: _MiniInfo(
                    icon: Icons.confirmation_number_outlined,
                    titulo: 'TIPO',
                    valor: 'Evento',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _CardInfo(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF9A77D5),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Localização',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    evento.local,
                    style: const TextStyle(
                      color: Color(0xFF63D13E),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    evento.endereco,
                    style: const TextStyle(color: Colors.white60, height: 1.35),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _abrirGoogleMaps(context),
                      icon: const Icon(Icons.directions_outlined),
                      label: const Text('Abrir no Google Maps'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF7C2BDC)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardInfo extends StatelessWidget {
  final Widget child;

  const _CardInfo({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF140E32),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF7C2BDC).withValues(alpha: .28),
        ),
      ),
      child: child,
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String valor;

  const _MiniInfo({
    required this.icon,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF140E32),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF9A77D5)),
          const SizedBox(height: 7),
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            valor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
