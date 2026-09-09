import 'package:evena/models/perfil.dart';
import 'package:evena/services/api_service.dart';

class AuthService {
  AuthService._();

  static Perfil? _perfilAtual;

  static Perfil? get perfilAtual => _perfilAtual;

  static bool get estaLogado => _perfilAtual != null;

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

  static Future<String?> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      final data =
      await ApiService.post(
        '/perfis/cadastrar',
        body: {
          'nome': nome.trim(),
          'email': normalizarEmail(email),
          'senha': senha,
        },
      )
      as Map<String, dynamic>;

      _perfilAtual = Perfil.fromJson(data);
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
      final data =
      await ApiService.post(
        '/perfis/autenticar',
        body: {'email': normalizarEmail(email), 'senha': senha},
      )
      as Map<String, dynamic>;

      _perfilAtual = Perfil.fromJson(data);
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

  static void sair() {
    _perfilAtual = null;
  }
}