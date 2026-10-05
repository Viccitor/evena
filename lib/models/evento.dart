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
  final List<String> comodidades;
  final double? preco;
  final String organizador;
  final String? linkIngressos;

  Evento({
    required this.id,
    required this.titulo,
    required this.imagemUrl,
    required DateTime? inicio,
    DateTime? fim,
    required this.local,
    required this.endereco,
    required this.descricao,
    required this.formato,
    required this.categoria,
    this.classificacao = 'Livre',
    required this.latitude,
    required this.longitude,
    this.comodidades = const [],
    this.preco,
    this.organizador = 'Evena Oficial',
    this.linkIngressos,
    // Parâmetros opcionais para compatibilidade retroativa com código legado
    String? dia,
    String? mes,
    String? hora,
  })  : inicio = inicio ?? _converterDataRelativa(dia, mes, hora),
        fim = fim ?? (inicio ?? _converterDataRelativa(dia, mes, hora));

  // Auxiliar para converter os parâmetros legados em DateTime caso inicio venha nulo
  static DateTime _converterDataRelativa(String? diaStr, String? mesStr, String? horaStr) {
    final agora = DateTime.now();
    final dia = int.tryParse(diaStr ?? '') ?? agora.day;

    const meses = [
      'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN',
      'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ'
    ];
    int mes = agora.month;
    if (mesStr != null) {
      final index = meses.indexOf(mesStr.toUpperCase());
      if (index != -1) mes = index + 1;
    }

    int hora = agora.hour;
    int minuto = 0;
    if (horaStr != null) {
      final partes = horaStr.replaceAll('h', ':').split(':');
      if (partes.isNotEmpty) hora = int.tryParse(partes[0]) ?? hora;
      if (partes.length > 1) minuto = int.tryParse(partes[1]) ?? 0;
    }

    return DateTime(agora.year, mes, dia, hora, minuto);
  }

  factory Evento.fromJson(Map<String, dynamic> json) {
    final datas = (json['datas'] as List? ?? [])
        .map((e) => e.toString())
        .toList();

    DateTime? inicio;

    if (datas.isNotEmpty) {
      inicio = DateTime.tryParse(datas.first);
    }

    DateTime? fim;

    if (datas.isNotEmpty) {
      fim = DateTime.tryParse(datas.last);
    }

    return Evento(
      id: (json['id'] ?? '').toString(),

      titulo:
      (json['titulo'] ?? '').toString(),

      imagemUrl:
      (json['capa'] ??
          json['banner'] ??
          '').toString(),

      inicio: inicio,

      fim: fim,

      local:
      (json['local'] ?? '').toString(),

      endereco:
      (json['endereco'] ?? '').toString(),

      descricao:
      (json['descricao'] ?? '').toString(),

      formato: 'Presencial',

      categoria:
      (json['categoria'] ?? '').toString(),

      classificacao:
      (json['classificacao'] ?? 'Livre')
          .toString(),

      latitude: double.tryParse(
        (json['latitude'] ?? 0).toString(),
      ) ?? 0,

      longitude: double.tryParse(
        (json['longitude'] ?? 0).toString(),
      ) ?? 0,

      preco: double.tryParse(
        (json['preco'] ?? '').toString(),
      ),

      organizador:
      (json['empresaNome'] ??
          'Evena Oficial')
          .toString(),

      linkIngressos:
      json['link']?.toString(),
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
      'comodidades': comodidades,
      'preco': preco,
      'organizador': organizador,
      'linkIngressos': linkIngressos,
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