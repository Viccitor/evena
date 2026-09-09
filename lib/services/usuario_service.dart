import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Modelo simplificado para representar o usuário logado
class Usuario {
  final String id;
  final String nome;
  final String email;
  final String? fotoUrl;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    this.fotoUrl,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      nome: (json['nome'] ?? json['name'] ?? 'Usuário').toString(),
      email: (json['email'] ?? '').toString(),
      fotoUrl: json['fotoUrl'] ?? json['avatar'] ?? json['imagem'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'fotoUrl': fotoUrl,
    };
  }
}

class UsuarioService extends ChangeNotifier {
  UsuarioService._();

  static final UsuarioService instance = UsuarioService._();

  Usuario? _usuarioAtual;
  bool _carregando = true;

  Usuario? get usuario => _usuarioAtual;
  bool get estaLogado => _usuarioAtual != null;
  bool get carregando => _carregando;

  // Primeiro nome para saudações (Ex: "Olá, João!")
  String get primeiroNome {
    if (_usuarioAtual == null || _usuarioAtual!.nome.isEmpty) {
      return 'Visitante';
    }
    return _usuarioAtual!.nome.trim().split(' ').first;
  }

  /// Chamado na inicialização do app (main.dart) para restaurar a sessão do usuário
  Future<void> carregarSessaoSalva() async {
    _carregando = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final dadosString = prefs.getString('usuario_logado');

      if (dadosString != null) {
        final Map<String, dynamic> jsonMap = jsonDecode(dadosString);
        _usuarioAtual = Usuario.fromJson(jsonMap);
      }
    } catch (_) {
      _usuarioAtual = null;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  /// Chamado logo após o login ser efetuado com sucesso na API
  Future<void> salvarSessao(Map<String, dynamic> dadosUsuario) async {
    _usuarioAtual = Usuario.fromJson(dadosUsuario);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario_logado', jsonEncode(_usuarioAtual!.toJson()));

    notifyListeners();
  }

  /// Chamado para encerrar a sessão do usuário
  Future<void> deslogar() async {
    _usuarioAtual = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario_logado');

    notifyListeners();
  }
}