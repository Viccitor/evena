import 'dart:convert';

import 'package:evena/models/perfil.dart';
import 'package:evena/services/api_service.dart';
import 'package:evena/services/favoritos_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService._();

  static const String _chaveSessao = 'perfil_logado';
  static const String _chaveSessaoLegada = 'usuario_logado';

  /// Única fonte de verdade do usuário logado.
  /// Use [perfilListenable] em ValueListenableBuilder para a UI reagir
  /// a login/logout.
  static final ValueNotifier<Perfil?> perfilListenable =
  ValueNotifier<Perfil?>(null);

  static Perfil? get perfilAtual => perfilListenable.value;

  static bool get estaLogado => perfilAtual != null;

  static const Set<String> _emailsAdmin = {
    're.ls.freitas23@gmail.com',
    'victor.m.marley@gmail.com',
  };

  static bool get ehAdmin {
    final email = normalizarEmail(perfilAtual?.email ?? '');
    return _emailsAdmin.contains(email);
  }

  // ---------------------------------------------------------------------------
  // Sessão
  // ---------------------------------------------------------------------------

  /// Chamar no main() antes do runApp para restaurar o login salvo.
  static Future<void> restaurarSessao() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dados = prefs.getString(_chaveSessao);

      if (dados != null) {
        perfilListenable.value = Perfil.fromJson(
          jsonDecode(dados) as Map<String, dynamic>,
        );
      }

      // Remove a chave antiga usada pelo UsuarioService.
      await prefs.remove(_chaveSessaoLegada);
    } catch (_) {
      perfilListenable.value = null;
    }
  }

  static Future<void> _iniciarSessao(Perfil perfil) async {
    perfilListenable.value = perfil;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_chaveSessao, jsonEncode(perfil.toJson()));
    } catch (_) {
      // Se não conseguir salvar, o usuário continua logado nesta execução.
    }
  }

  static Future<void> sair() async {
    perfilListenable.value = null;
    FavoritosService.instance.limpar();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_chaveSessao);
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // Validações
  // ---------------------------------------------------------------------------

  static String normalizarEmail(String email) => email.trim().toLowerCase();

  static String? validarEmail(String email) {
    final valor = normalizarEmail(email);

    if (valor.isEmpty) {
      return 'Digite seu e-mail.';
    }

    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!regex.hasMatch(valor)) {
      return 'Digite um e-mail válido.';
    }

    return null;
  }

  static String? validarSenha(String senha) {
    if (senha.length < 8) {
      return 'Use pelo menos 8 caracteres.';
    }

    if (!RegExp(r'[A-Z]').hasMatch(senha)) {
      return 'Adicione pelo menos uma letra maiúscula.';
    }

    if (!RegExp(r'[a-z]').hasMatch(senha)) {
      return 'Adicione pelo menos uma letra minúscula.';
    }

    if (!RegExp(r'[0-9]').hasMatch(senha)) {
      return 'Adicione pelo menos um número.';
    }

    return null;
  }

  static String? validarEmailDeLogin(String email) {
    return validarEmail(email);
  }

  static String? validarSenhaDeLogin(String senha) {
    if (senha.isEmpty) {
      return 'Digite sua senha.';
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // API
  // ---------------------------------------------------------------------------

  static Future<String?> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      final data = await ApiService.post(
        '/perfis/cadastrar',
        body: {
          'nome': nome.trim(),
          'email': normalizarEmail(email),
          'senha': senha,
        },
      ) as Map<String, dynamic>;

      await _iniciarSessao(Perfil.fromJson(data));
      return null;
    } on ApiException catch (erro) {
      return erro.mensagem;
    } catch (_) {
      return 'Não foi possível conectar com a API.';
    }
  }

  static Future<String?> entrar({
    required String email,
    required String senha,
  }) async {
    try {
      final data = await ApiService.post(
        '/perfis/autenticar',
        body: {'email': normalizarEmail(email), 'senha': senha},
      ) as Map<String, dynamic>;

      await _iniciarSessao(Perfil.fromJson(data));
      return null;
    } on ApiException catch (erro) {
      return erro.mensagem;
    } catch (_) {
      return 'Não foi possível conectar com a API.';
    }
  }

  static Future<String?> recuperarSenha({
    required String email,
    required String novaSenha,
  }) async {
    try {
      await ApiService.post(
        '/perfis/recuperar-senha',
        body: {'email': normalizarEmail(email), 'novaSenha': novaSenha},
      );

      return null;
    } on ApiException catch (erro) {
      return erro.mensagem;
    } catch (_) {
      return 'Não foi possível conectar com a API.';
    }
  }
}