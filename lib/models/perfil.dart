class Perfil {
  final int id;
  final String nome;
  final String email;
  final String? telefone;
  final String? foto;
  final String? banner;
  final String? descricao;

  const Perfil({
    required this.id,
    required this.nome,
    required this.email,
    this.telefone,
    this.foto,
    this.banner,
    this.descricao,
  });

  /// Primeiro nome para saudações (ex.: "Olá, João!").
  String get primeiroNome {
    final partes = nome.trim().split(RegExp(r'\s+'));
    return partes.first.isEmpty ? 'Visitante' : partes.first;
  }

  factory Perfil.fromJson(Map<String, dynamic> json) {
    return Perfil(
      id: json['id'] as int,
      nome: json['nome']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      telefone: json['telefone']?.toString(),
      foto: json['foto']?.toString(),
      banner: json['banner']?.toString(),
      descricao: json['descricao']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'foto': foto,
      'banner': banner,
      'descricao': descricao,
    };
  }
}