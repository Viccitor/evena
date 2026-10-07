import 'package:flutter/foundation.dart';

const List<String> _mesesAbrev = [
  'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN',
  'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ',
];

const List<String> _diasSemanaAbrev = [
  'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB', 'DOM',
];

const List<String> _diasSemanaExtenso = [
  'Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Quinta-feira',
  'Sexta-feira', 'Sábado', 'Domingo',
];

DateTime? _lerDataHora(dynamic valor) {
  if (valor == null) return null;
  return DateTime.tryParse(valor.toString());
}

/// Uma data do evento (um evento pode ter várias).
/// A API hoje só guarda o início ("dataHora"); [fim] é opcional.
class DataEvento {
  final DateTime inicio;
  final DateTime? fim;

  const DataEvento({required this.inicio, this.fim});

  DateTime get fimOuInicio => fim ?? inicio;

  String get dia => inicio.day.toString().padLeft(2, '0');
  String get mes => _mesesAbrev[inicio.month - 1];
  String get diaSemanaAbrev => _diasSemanaAbrev[inicio.weekday - 1];
  String get diaSemanaExtenso => _diasSemanaExtenso[inicio.weekday - 1];

  String get hora => _formatarHora(inicio);

  /// "19:00" ou "19:00 – 22:00" (quando há término diferente do início).
  String get intervaloHora {
    final f = fim;
    if (f == null || f == inicio) return hora;
    return '$hora – ${_formatarHora(f)}';
  }

  static String _formatarHora(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  /// Aceita "2026-10-07T19:00:00" ou {"dataHora": "...", "fim": "..."}.
  /// Devolve null se não der para entender a data.
  static DataEvento? tentarLer(dynamic bruto) {
    if (bruto is Map) {
      final inicio = _lerDataHora(
        bruto['dataHora'] ?? bruto['inicio'] ?? bruto['data'],
      );
      if (inicio == null) return null;
      return DataEvento(
        inicio: inicio,
        fim: _lerDataHora(bruto['dataHoraFim'] ?? bruto['fim']),
      );
    }

    final inicio = _lerDataHora(bruto);
    return inicio == null ? null : DataEvento(inicio: inicio);
  }

  Map<String, dynamic> toJson() => {
    'inicio': inicio.toIso8601String(),
    'fim': fim?.toIso8601String(),
  };
}

/// Uma atração do evento (banda, artista, palestrante...).
/// Na API é salva como "artista": nome, obras (descrição) e foto.
class Atracao {
  final String nome;
  final String descricao;
  final String? foto;

  const Atracao({required this.nome, this.descricao = '', this.foto});

  /// A descrição pode vir como texto ou como lista de textos.
  static String _lerTexto(dynamic valor) {
    if (valor == null) return '';
    if (valor is List) {
      return valor
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .join(', ');
    }
    return valor.toString().trim();
  }

  static Atracao? tentarLer(dynamic bruto) {
    if (bruto is Map) {
      final nome = (bruto['nome'] ?? bruto['titulo'] ?? '').toString().trim();
      if (nome.isEmpty) return null;

      if (kDebugMode) debugPrint('Atração recebida da API: $bruto');

      final descricao = _lerTexto(
        bruto['obras'] ??
            bruto['descricao'] ??
            bruto['biografia'] ??
            bruto['bio'] ??
            bruto['sobre'] ??
            bruto['detalhes'],
      );
      final foto = bruto['foto']?.toString().trim();

      return Atracao(
        nome: nome,
        descricao: descricao,
        foto: (foto == null || foto.isEmpty) ? null : foto,
      );
    }

    final nome = bruto?.toString().trim() ?? '';
    return nome.isEmpty ? null : Atracao(nome: nome);
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'descricao': descricao,
    'foto': foto,
  };
}

class Evento {
  final String id;
  final String titulo;
  final String imagemUrl;
  /// Todas as datas do evento, em ordem. Sempre tem pelo menos uma.
  final List<DataEvento> datas;
  final List<Atracao> atracoes;
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
  final String? linkTransmissao;
  final bool ativo;

  Evento({
    required this.id,
    required this.titulo,
    required this.imagemUrl,
    required DateTime? inicio,
    DateTime? fim,
    List<DataEvento>? datas,
    this.atracoes = const [],
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
    this.linkTransmissao,
    this.ativo = true,
    // Parâmetros opcionais para compatibilidade retroativa com código legado
    String? dia,
    String? mes,
    String? hora,
  }) : datas = _montarDatas(datas, inicio, fim, dia, mes, hora);

  // Compatibilidade: início/fim do evento = primeira/última data.
  DateTime get inicio => datas.first.inicio;
  DateTime get fim => datas.last.fimOuInicio;
  bool get temVariasDatas => datas.length > 1;

  static List<DataEvento> _montarDatas(
      List<DataEvento>? datas,
      DateTime? inicio,
      DateTime? fim,
      String? dia,
      String? mes,
      String? hora,
      ) {
    if (datas != null && datas.isNotEmpty) {
      final ordenadas = [...datas]
        ..sort((a, b) => a.inicio.compareTo(b.inicio));
      return List.unmodifiable(ordenadas);
    }

    final primeira = inicio ?? _converterDataRelativa(dia, mes, hora);
    return [DataEvento(inicio: primeira, fim: fim ?? primeira)];
  }

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
    // "datas" pode vir como lista de textos ou de objetos ({dataHora: ...}).
    final datas = <DataEvento>[];
    for (final item in (json['datas'] as List? ?? const [])) {
      final data = DataEvento.tentarLer(item);
      if (data != null) datas.add(data);
    }

    // "artistas" é como a API chama as atrações.
    final atracoes = <Atracao>[];
    final brutas = json['artistas'] ?? json['atracoes'];
    for (final item in (brutas as List? ?? const [])) {
      final atracao = Atracao.tentarLer(item);
      if (atracao != null) atracoes.add(atracao);
    }

    return Evento(
      id: (json['id'] ?? '').toString(),

      titulo:
      (json['titulo'] ?? '').toString(),

      imagemUrl:
      (json['capa'] ??
          json['banner'] ??
          '').toString(),

      datas: datas,

      atracoes: atracoes,

      inicio: null,

      local:
      (json['local'] ?? '').toString(),

      endereco:
      (json['endereco'] ?? '').toString(),

      descricao:
      (json['descricao'] ?? '').toString(),

      formato: _inferirFormato(json),

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

      linkIngressos: json['link']?.toString(),


      linkTransmissao: json['linkTransmissao']?.toString() ??
          (json['linkLive']?.toString()),

      ativo: json['status'] != false,
    );
  }


  static String _inferirFormato(Map<String, dynamic> json) {
    final formato = json['formato']?.toString().trim();
    if (formato != null && formato.isNotEmpty) return formato;

    final local = json['local']?.toString().trim() ?? '';
    final endereco = json['endereco']?.toString().trim() ?? '';
    final link = json['link']?.toString().trim() ?? '';

    if (local.isEmpty && endereco.isEmpty && link.isNotEmpty) {
      return 'Online';
    }
    return 'Presencial';
  }

  bool get online => formato.toLowerCase() == 'online';
  String get localExibicao => online ? 'Evento online' : local;

  // Alias para manter compatibilidade caso algum ponto use 'fromMap'
  factory Evento.fromMap(Map<String, dynamic> map) => Evento.fromJson(map);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'imagemUrl': imagemUrl,
      'inicio': inicio.toIso8601String(),
      'fim': fim.toIso8601String(),
      'datas': datas.map((d) => d.toJson()).toList(),
      'atracoes': atracoes.map((a) => a.toJson()).toList(),
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
      'linkTransmissao': linkTransmissao,
      'status': ativo,
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