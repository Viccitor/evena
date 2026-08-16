class AuthService {
  AuthService._();

  static final Map<String, _UsuarioLocal> _usuarios = {};

  static String normalizarEmail(String email) => email.trim().toLowerCase();

  static String? validarEmail(String email) {
    final valor = normalizarEmail(email);

    if (valor.isEmpty) {
      return 'Digite seu e-mail.';
    }

    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!regex.hasMatch(valor)) {
      return 'Digite um e-mail v\u00e1lido.';
    }

    return null;
  }

  static String? validarSenha(String senha) {
    if (senha.length < 8) {
      return 'Use pelo menos 8 caracteres.';
    }

    if (!RegExp(r'[A-Z]').hasMatch(senha)) {
      return 'Adicione pelo menos uma letra mai\u00fascula.';
    }

    if (!RegExp(r'[a-z]').hasMatch(senha)) {
      return 'Adicione pelo menos uma letra min\u00fascula.';
    }

    if (!RegExp(r'[0-9]').hasMatch(senha)) {
      return 'Adicione pelo menos um n\u00famero.';
    }

    return null;
  }

  static String? validarEmailDeLogin(String email) {
    final erro = validarEmail(email);
    if (erro != null) {
      return erro;
    }

    if (!_usuarios.containsKey(normalizarEmail(email))) {
      return 'E-mail n\u00e3o cadastrado.';
    }

    return null;
  }

  static String? validarSenhaDeLogin(String email, String senha) {
    if (senha.isEmpty) {
      return 'Digite sua senha.';
    }

    final usuario = _usuarios[normalizarEmail(email)];

    if (usuario != null && usuario.senha != senha) {
      return 'Senha incorreta.';
    }

    return null;
  }

  static String? cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) {
    final nomeLimpo = nome.trim();
    final emailNormalizado = normalizarEmail(email);

    if (nomeLimpo.isEmpty) {
      return 'Digite seu nome.';
    }

    final erroEmail = validarEmail(emailNormalizado);
    if (erroEmail != null) {
      return erroEmail;
    }

    final erroSenha = validarSenha(senha);
    if (erroSenha != null) {
      return erroSenha;
    }

    if (_usuarios.containsKey(emailNormalizado)) {
      return 'J\u00e1 existe uma conta com esse e-mail.';
    }

    _usuarios[emailNormalizado] = _UsuarioLocal(
      nome: nomeLimpo,
      email: emailNormalizado,
      senha: senha,
    );

    return null;
  }

  static String? entrar({required String email, required String senha}) {
    final erroEmail = validarEmailDeLogin(email);
    if (erroEmail != null) {
      return erroEmail;
    }

    final erroSenha = validarSenhaDeLogin(email, senha);
    if (erroSenha != null) {
      return erroSenha;
    }

    return null;
  }
}

class _UsuarioLocal {
  final String nome;
  final String email;
  final String senha;

  const _UsuarioLocal({
    required this.nome,
    required this.email,
    required this.senha,
  });
}
