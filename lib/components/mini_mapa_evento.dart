import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Mini mapa do local do evento.
///
/// - Android/iOS: mostra o mesmo mapa embutido do Google Maps usado no site
///   (visual idêntico, interativo, sem chave de API).
/// - Windows/Linux/web: usa OpenStreetMap como alternativa.
/// - Some sozinho se o evento não tiver coordenadas válidas (0,0).
class MiniMapaEvento extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String titulo;
  final String local;
  final double altura;

  const MiniMapaEvento({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.titulo,
    required this.local,
    this.altura = 220,
  });

  bool get _coordenadasValidas =>
      !(latitude == 0 && longitude == 0) &&
          latitude.abs() <= 90 &&
          longitude.abs() <= 180;

  bool get _usaWebView =>
      !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Widget build(BuildContext context) {
    if (!_coordenadasValidas) {
      return const SizedBox.shrink();
    }

    return Container(
      height: altura,
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFF7C2BDC).withValues(alpha: .35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: _usaWebView
            ? _MapaGoogleEmbed(latitude: latitude, longitude: longitude)
            : _MapaOpenStreetMap(latitude: latitude, longitude: longitude),
      ),
    );
  }
}

/// Mapa do Google (mesmo embed do site) dentro de uma WebView.
class _MapaGoogleEmbed extends StatefulWidget {
  final double latitude;
  final double longitude;

  const _MapaGoogleEmbed({required this.latitude, required this.longitude});

  @override
  State<_MapaGoogleEmbed> createState() => _MapaGoogleEmbedState();
}

class _MapaGoogleEmbedState extends State<_MapaGoogleEmbed> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final src = Uri.https('maps.google.com', '/maps', {
      'q': '${widget.latitude},${widget.longitude}',
      'z': '15',
      'hl': 'pt-BR',
      'output': 'embed',
    }).toString();

    // O embed do Google só funciona dentro de um <iframe>, então carregamos
    // uma página HTML mínima que contém o iframe (igual ao que o site faz).
    final srcSeguro = const HtmlEscape(HtmlEscapeMode.attribute).convert(src);

    final html = '''
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
      html, body { margin: 0; padding: 0; height: 100%; background: #e5e3df; }
      iframe { border: 0; width: 100%; height: 100%; }
    </style>
  </head>
  <body>
    <iframe
      src="$srcSeguro"
      allowfullscreen
      referrerpolicy="no-referrer-when-downgrade"></iframe>
  </body>
</html>
''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFE5E3DF))
      ..loadHtmlString(html, baseUrl: 'https://localhost/');
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
      // Faz o mapa receber os gestos (arrastar/zoom) mesmo dentro de um
      // SingleChildScrollView.
      gestureRecognizers: {
        Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
        ),
      },
    );
  }
}

/// Alternativa gratuita para plataformas sem WebView (Windows/Linux/web).
class _MapaOpenStreetMap extends StatelessWidget {
  final double latitude;
  final double longitude;

  const _MapaOpenStreetMap({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    final posicao = LatLng(latitude, longitude);

    return FlutterMap(
      options: MapOptions(
        initialCenter: posicao,
        initialZoom: 15,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.none,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          // Troque pelo applicationId do seu app (android/app/build.gradle)
          userAgentPackageName: 'com.example.evena',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: posicao,
              width: 44,
              height: 44,
              alignment: Alignment.topCenter,
              child: const Icon(
                Icons.location_on_rounded,
                color: Color(0xFFE53935),
                size: 44,
              ),
            ),
          ],
        ),
        const SimpleAttributionWidget(source: Text('© OpenStreetMap')),
      ],
    );
  }
}