import 'package:evena/models/evento.dart';
import 'package:evena/services/api_service.dart';
import 'package:evena/services/auth_service.dart';
import 'package:flutter/foundation.dart';

class FavoritosService extends ChangeNotifier {
  FavoritosService._();

  static final FavoritosService instance = FavoritosService._();

  final Set<String> _ids = <String>{};

  Set<String> get ids => Set.unmodifiable(_ids);

  bool contem(String eventoId) => _ids.contains(eventoId);

  Future<void> carregar() async {
    final perfil = AuthService.perfilAtual;

    if (perfil == null) {
      notifyListeners();
      return;
    }

    try {
      final data =
      await ApiService.get('/perfis/${perfil.id}/favoritos')
      as List<dynamic>;

      _ids
        ..clear()
        ..addAll(
          data.map((item) => Evento.fromJson(item as Map<String, dynamic>).id),
        );

      notifyListeners();
    } catch (_) {
      notifyListeners();
    }
  }

  Future<bool> alternar(String eventoId) async {
    final perfil = AuthService.perfilAtual;
    final favoritado = contem(eventoId);

    if (perfil == null) {
      if (favoritado) {
        _ids.remove(eventoId);
      } else {
        _ids.add(eventoId);
      }

      notifyListeners();
      return true;
    }

    try {
      if (favoritado) {
        await ApiService.delete('/perfis/${perfil.id}/favoritos/$eventoId');
        _ids.remove(eventoId);
      } else {
        await ApiService.post('/perfis/${perfil.id}/favoritos/$eventoId');
        _ids.add(eventoId);
      }

      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  void limpar() {
    _ids.clear();
    notifyListeners();
  }
}