import 'package:evena/components/card_secao.dart';
import 'package:evena/models/evento.dart';
import 'package:evena/services/favoritos_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:evena/components/mini_mapa_evento.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:evena/components/card_comodidade.dart';
import 'package:share_plus/share_plus.dart';
import 'package:evena/components/secao_compra_evento.dart';
import 'package:evena/components/seletor_data_evento.dart';
import 'package:evena/components/secao_atracoes_evento.dart';

class TelaDetalheEvento extends StatefulWidget {
  final Evento evento;

  const TelaDetalheEvento({super.key, required this.evento});

  @override
  State<TelaDetalheEvento> createState() => _TelaDetalheEventoState();
}

class _TelaDetalheEventoState extends State<TelaDetalheEvento> {
  Evento get evento => widget.evento;

  /// Índice da data escolhida na aba de datas.
  int _indiceData = 0;

  DataEvento get _dataAtual {
    final ultimo = evento.datas.length - 1;
    return evento.datas[_indiceData.clamp(0, ultimo)];
  }

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

  Future<void> _abrirIngressos(BuildContext context) async {
    final uri = Uri.tryParse(evento.linkIngressos ?? '');

    if (uri == null) return;

    await _abrirUrl(context, uri, 'Não foi possível abrir o link dos ingressos.');
  }

  Future<void> _alternarFavorito(BuildContext context) async {
    final sucesso = await FavoritosService.instance.alternar(evento.id);

    if (!sucesso && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível atualizar os favoritos.')),
      );
    }
  }

  String _slugEvento(String titulo) {
    var slug = titulo.toLowerCase().trim();

    const acentos = {
      'á': 'a', 'à': 'a', 'ã': 'a', 'â': 'a', 'ä': 'a',
      'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
      'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
      'ó': 'o', 'ò': 'o', 'õ': 'o', 'ô': 'o', 'ö': 'o',
      'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
      'ç': 'c',
    };

    acentos.forEach((comAcento, semAcento) {
      slug = slug.replaceAll(comAcento, semAcento);
    });

    return slug
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  String _linkPublicoEvento() {
    return 'https://evena.online/detalhes-evento/${_slugEvento(evento.titulo)}';
  }

  Future<void> _compartilhar(BuildContext context) async {
    final localTexto = evento.online
        ? 'Evento online'
        : '${evento.local} - ${evento.endereco}';
    final linkEvento = _linkPublicoEvento();
    final texto =
        '${evento.titulo}\n'
        '${evento.datas.map((d) => '${d.dia} ${d.mes} • ${d.hora}').join('\n')}\n'
        '$localTexto\n\n'
        'Veja no Evena:\n$linkEvento';

    await SharePlus.instance.share(
      ShareParams(
        text: texto,
        subject: evento.titulo,
      ),
    );
  }

  void _reportar(BuildContext context) {
    // Provisório: ainda não existe endpoint de denúncia na API.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ta com pressa?')),
    );
  }

  Future<void> _abrirGoogleCalendar(BuildContext context) async {
    final uri = Uri.https('calendar.google.com', '/calendar/render', {
      'action': 'TEMPLATE',
      'text': evento.titulo,
      'dates': '${_dataGoogle(_dataAtual.inicio)}/${_dataGoogle(_dataAtual.fimOuInicio)}',
      'details': evento.descricao,
      'location': evento.online
          ? 'Online'
          : '${evento.local} - ${evento.endereco}',
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
        title: InkWell(
          onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/images/logo_evena_s_fundo.png',
            height: 82,
          ),
        ),
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
            if (evento.temVariasDatas) ...[
              SeletorDataEvento(
                datas: evento.datas,
                selecionada: _indiceData,
                onSelecionar: (i) => setState(() => _indiceData = i),
              ),
              const SizedBox(height: 18),
            ],
            AnimatedBuilder(
              animation: favoritos,
              builder: (context, _) => SecaoCompraEvento(
                preco: evento.preco,
                organizador: evento.organizador,
                seguidores: 0,
                dataTexto: formatarDataExtenso(_dataAtual.inicio),
                horaTexto: _dataAtual.hora,
                favoritado: favoritos.contem(evento.id),
                onGarantirIngressos: (evento.linkIngressos ?? '').isEmpty
                    ? null
                    : () => _abrirIngressos(context),
                onSalvar: () => _alternarFavorito(context),
                onAgenda: () => _abrirGoogleCalendar(context),
                onCompartilhar: () => _compartilhar(context),
                onReportar: () => _reportar(context),
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
            if (evento.atracoes.isNotEmpty) ...[
              const SizedBox(height: 20),
              SecaoAtracoesEvento(atracoes: evento.atracoes),
            ],
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
              child: evento.online
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.language_rounded,
                        color: Color(0xFF9A77D5),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Evento online',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Este evento acontece pela internet.',
                    style: TextStyle(color: Colors.white70, height: 1.4),
                  ),
                  if ((evento.linkIngressos ?? '').isNotEmpty) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _abrirIngressos(context),
                        icon: const Icon(Icons.open_in_new_rounded, size: 17),
                        label: const Text('Acessar evento online'),
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
                ],
              )
                  : Column(
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
                      color: Color(0xFF00FF00),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    evento.endereco,
                    style: const TextStyle(
                      color: Colors.white60,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _abrirGoogleMaps(context),
                      icon: const FaIcon(
                        FontAwesomeIcons.mapLocationDot,
                        size: 16,
                      ),
                      label: const Text('Como chegar'),
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
                  const SizedBox(height: 14),
                  MiniMapaEvento(
                    latitude: evento.latitude,
                    longitude: evento.longitude,
                    titulo: evento.titulo,
                    local: evento.local,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            CardSecao(
              titulo: 'Comodidades e Facilidades',
              icone: Icons.checklist_rounded,
              conteudo: GradeComodidades(ativas: evento.comodidades),
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