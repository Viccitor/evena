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
}
