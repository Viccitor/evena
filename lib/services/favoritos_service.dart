import 'package:flutter/foundation.dart';

class FavoritosService extends ChangeNotifier {
  FavoritosService._();

  static final FavoritosService instance = FavoritosService._();

  final Set<String> _ids = <String>{};

  Set<String> get ids => Set.unmodifiable(_ids);

  bool contem(String eventoId) => _ids.contains(eventoId);

  void alternar(String eventoId) {
    if (!_ids.add(eventoId)) {
      _ids.remove(eventoId);
    }
    notifyListeners();
  }
}
