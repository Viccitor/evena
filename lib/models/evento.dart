class Evento {
  final String id;
  final String titulo;
  final String imagemUrl;
  final DateTime inicio;
  final DateTime fim;
  final String local;
  final String endereco;
  final String descricao;
  final String formato;
  final String categoria;
  final String classificacao;
  final double preco;
  final String? link;

  const Evento({
    required this.id,
    required this.titulo,
    required this.imagemUrl,
    required this.inicio,
    required this.fim,
    required this.local,
    required this.endereco,
    required this.descricao,
    required this.formato,
    required this.categoria,
    required this.classificacao,
    required this.preco,
    this.link,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    final datas = (json['datas'] as List<dynamic>? ?? [])
        .map((data) => DateTime.parse(data.toString()))
        .toList();

    final inicio = datas.isNotEmpty ? datas.first : DateTime.now();
    final fim = datas.length > 1
        ? datas[1]
        : inicio.add(const Duration(hours: 2));

    final imagem = json['capa']?.toString().trim();

    return Evento(
      id: json['id'].toString(),
      titulo: json['titulo']?.toString() ?? '',
      imagemUrl: imagem == null || imagem.isEmpty
          ? 'assets/images/evento1.jpg'
          : imagem,
      inicio: inicio,
      fim: fim,
      local: json['local']?.toString() ?? 'Local a definir',
      endereco: json['endereco']?.toString() ?? '',
      descricao: json['descricao']?.toString() ?? '',
      formato: 'Presencial',
      categoria: json['categoria']?.toString() ?? 'Evento',
      classificacao: json['classificacao']?.toString() ?? 'Livre',
      preco: (json['preco'] as num?)?.toDouble() ?? 0,
      link: json['link']?.toString(),
    );
  }

  String get dia => inicio.day.toString().padLeft(2, '0');

  String get mes {
    const meses = [
      'JAN',
      'FEV',
      'MAR',
      'ABR',
      'MAI',
      'JUN',
      'JUL',
      'AGO',
      'SET',
      'OUT',
      'NOV',
      'DEZ',
    ];

    return meses[inicio.month - 1];
  }

  String get hora =>
      '${inicio.hour.toString().padLeft(2, '0')}:${inicio.minute.toString().padLeft(2, '0')}';
}
