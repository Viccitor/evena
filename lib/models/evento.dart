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
  final double latitude;
  final double longitude;

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
     this.classificacao = 'Livre',
    required this.latitude,
    required this.longitude,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      titulo: (json['titulo'] ?? json['title'] ?? json['nome'] ?? '').toString(),
      imagemUrl: (json['imagemUrl'] ?? json['image'] ?? json['imageUrl'] ?? json['banner'] ?? '').toString(),
      inicio: json['inicio'] != null
          ? DateTime.tryParse(json['inicio'].toString()) ?? DateTime.now()
          : (json['startDate'] != null
          ? DateTime.tryParse(json['startDate'].toString()) ?? DateTime.now()
          : DateTime.now()),
      fim: json['fim'] != null
          ? DateTime.tryParse(json['fim'].toString()) ?? DateTime.now()
          : (json['endDate'] != null
          ? DateTime.tryParse(json['endDate'].toString()) ?? DateTime.now()
          : DateTime.now()),
      local: (json['local'] ?? json['place'] ?? json['venue'] ?? json['location'] ?? '').toString(),
      endereco: (json['endereco'] ?? json['address'] ?? '').toString(),
      descricao: (json['descricao'] ?? json['description'] ?? '').toString(),
      formato: (json['formato'] ?? json['format'] ?? json['type'] ?? '').toString(),
      categoria: (json['categoria'] ?? json['category'] ?? '').toString(),
      classificacao: (json['classificacao'] ?? json['rating'] ?? 'Livre').toString(),
      latitude: double.tryParse((json['latitude'] ?? json['lat'] ?? 0).toString()) ?? 0.0,
      longitude: double.tryParse((json['longitude'] ?? json['lng'] ?? json['lon'] ?? 0).toString()) ?? 0.0,
    );
  }

  // Alias para manter compatibilidade caso algum ponto use 'fromMap'
  factory Evento.fromMap(Map<String, dynamic> map) => Evento.fromJson(map);


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'imagemUrl': imagemUrl,
      'inicio': inicio.toIso8601String(),
      'fim': fim.toIso8601String(),
      'local': local,
      'endereco': endereco,
      'descricao': descricao,
      'formato': formato,
      'categoria': categoria,
      'classificacao': classificacao,
      'latitude': latitude,
      'longitude': longitude,
    };
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