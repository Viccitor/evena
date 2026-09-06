import 'package:evena/models/evento.dart';
import 'package:evena/services/api_service.dart';
import 'package:flutter/foundation.dart';

class EventoService extends ChangeNotifier {
  EventoService._();

  static final EventoService instance = EventoService._();

  final List<Evento> _eventos = [];
  bool _carregando = false;
  String? _erro;

  List<Evento> get eventos => List.unmodifiable(_eventos);
  bool get carregando => _carregando;
  String? get erro => _erro;

  Future<void> carregar() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      final data = await ApiService.get('/eventos/ativos') as List<dynamic>;
      _eventos
        ..clear()
        ..addAll(
          data.map((item) => Evento.fromJson(item as Map<String, dynamic>)),
        );
    } on ApiException catch (erro) {
      _erro = erro.mensagem;
    } catch (_) {
      _erro = 'Não foi possível conectar com a API.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  List<Evento> pesquisar(String termo) {
    final valor = _normalizar(termo.trim());

    if (valor.isEmpty) {
      return eventos;
    }

    return _eventos.where((evento) {
      final alvo = _normalizar(
        '${evento.titulo} ${evento.categoria} ${evento.local} ${evento.endereco} ${evento.formato}',
      );

      return alvo.contains(valor);
    }).toList();
  }

  String _normalizar(String texto) {
    const comAcento = 'áàãâäéèêëíìîïóòõôöúùûüç';
    const semAcento = 'aaaaaeeeeiiiiooooouuuuc';
    var valor = texto.toLowerCase();

    for (var i = 0; i < comAcento.length; i++) {
      valor = valor.replaceAll(comAcento[i], semAcento[i]);
    }

    return valor;
  }
}
