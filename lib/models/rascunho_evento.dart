import 'dart:io';

import 'package:flutter/material.dart';

const List<String> formatosEvento = ['Presencial', 'Online', 'Híbrido'];

const List<String> classificacoesEvento = [
  'Livre',
  '10',
  '12',
  '14',
  '16',
  '18',
];

String doisDigitos(int valor) => valor.toString().padLeft(2, '0');

String formatarHora(TimeOfDay hora) {
  return '${doisDigitos(hora.hour)}:${doisDigitos(hora.minute)}';
}

String formatarDataCurta(DateTime data) {
  return '${doisDigitos(data.day)}/${doisDigitos(data.month)}/${data.year}';
}

/// Uma data do evento (dia + horário de início e, opcionalmente, término).
class DataRascunho {
  DateTime? data;
  TimeOfDay? inicio;
  TimeOfDay? fim;

  DataRascunho({this.data, this.inicio, this.fim});

  DateTime? get inicioCompleto {
    if (data == null || inicio == null) return null;
    return DateTime(
      data!.year,
      data!.month,
      data!.day,
      inicio!.hour,
      inicio!.minute,
    );
  }

  DateTime? get fimCompleto {
    final horaFinal = fim ?? inicio;
    if (data == null || horaFinal == null) return null;
    return DateTime(
      data!.year,
      data!.month,
      data!.day,
      horaFinal.hour,
      horaFinal.minute,
    );
  }
}

class AtracaoRascunho {
  final TextEditingController nome = TextEditingController();
  final TextEditingController descricao = TextEditingController();

  bool get vazia =>
      nome.text.trim().isEmpty && descricao.text.trim().isEmpty;

  void dispose() {
    nome.dispose();
    descricao.dispose();
  }
}

/// Guarda tudo o que o organizador preenche no assistente de criar evento.
/// Vive enquanto a tela de criar evento estiver aberta, então os dados
/// não se perdem ao trocar de passo.
class RascunhoEvento extends ChangeNotifier {
  // --- Passo 1: Informações ---
  final TextEditingController nome = TextEditingController();
  String? categoria;
  String? classificacao;
  final TextEditingController descricao = TextEditingController();
  File? capa;
  String? capaAsset;

  bool get temCapa => capa != null || capaAsset != null;

  void definirCapaArquivo(File arquivo) {
    capa = arquivo;
    capaAsset = null;
    atualizar();
  }

  void definirCapaAsset(String asset) {
    capa = null;
    capaAsset = asset;
    atualizar();
  }

  void removerCapa() {
    capa = null;
    capaAsset = null;
    atualizar();
  }

  // --- Passo 2: Data e local ---
  final List<DataRascunho> datas = [DataRascunho()];
  String? formato;
  final TextEditingController local = TextEditingController();
  final TextEditingController endereco = TextEditingController();
  final TextEditingController linkOnline = TextEditingController();

  // --- Passo 3: Detalhes ---
  bool? pago;
  final TextEditingController preco = TextEditingController();
  final TextEditingController linkIngressos = TextEditingController();
  final List<AtracaoRascunho> atracoes = [AtracaoRascunho()];
  final Set<String> comodidades = <String>{};
  final List<String> recursosExtras = [];
  final TextEditingController infoAdicionais = TextEditingController();
  final TextEditingController pergunta = TextEditingController();
  final TextEditingController resposta = TextEditingController();

  /// Quando true, os campos obrigatórios vazios mostram o erro na tela.
  bool mostrarErros = false;

  void atualizar() => notifyListeners();

  /// Chamado a cada letra digitada: só redesenha se os erros estão visíveis
  /// (assim o erro some assim que o campo é preenchido).
  void aoDigitar() {
    if (mostrarErros) notifyListeners();
  }

  bool get presencial => formato == 'Presencial' || formato == 'Híbrido';
  bool get online => formato == 'Online' || formato == 'Híbrido';

  double? get precoValor {
    final texto = preco.text.trim().replaceAll(',', '.');
    return double.tryParse(texto);
  }

  List<AtracaoRascunho> get atracoesPreenchidas =>
      atracoes.where((a) => a.nome.text.trim().isNotEmpty).toList();

  bool get temConteudo =>
      nome.text.trim().isNotEmpty ||
          descricao.text.trim().isNotEmpty ||
          temCapa;

  // ---------------------------------------------------------------------------
  // Validação
  // ---------------------------------------------------------------------------

  /// Retorna a primeira mensagem de erro do passo, ou null se está tudo certo.
  String? validarPasso(int passo) {
    switch (passo) {
      case 0:
        return _validarInformacoes();
      case 1:
        return _validarDataLocal();
      case 2:
        return _validarDetalhes();
      default:
        return null;
    }
  }

  /// Índice do primeiro passo (0 a 2) com problema, ou null.
  int? primeiroPassoComErro() {
    for (var passo = 0; passo < 3; passo++) {
      if (validarPasso(passo) != null) return passo;
    }
    return null;
  }

  String? _validarInformacoes() {
    if (nome.text.trim().isEmpty) return 'Informe o nome do evento.';
    if (categoria == null) return 'Selecione uma categoria.';
    if (classificacao == null) return 'Selecione a classificação etária.';
    if (descricao.text.trim().isEmpty) return 'Descreva o evento.';
    if (!temCapa) return 'Escolha a imagem de capa.';
    return null;
  }

  int _minutos(TimeOfDay hora) => hora.hour * 60 + hora.minute;

  String? _validarDataLocal() {
    for (var i = 0; i < datas.length; i++) {
      final item = datas[i];
      final numero = i + 1;

      if (item.data == null) return 'Informe a data $numero.';

      if (item.inicio == null) {
        return 'Informe o horário de início da data $numero.';
      }

      final fim = item.fim;
      if (fim != null && _minutos(fim) <= _minutos(item.inicio!)) {
        return 'O término da data $numero deve ser depois do início.';
      }
    }

    if (formato == null) return 'Escolha o formato do evento.';

    if (presencial) {
      if (local.text.trim().isEmpty) return 'Informe o nome do local.';
      if (endereco.text.trim().isEmpty) return 'Informe o endereço do evento.';
    }

    if (online && linkOnline.text.trim().isEmpty) {
      return 'Informe o link do evento online.';
    }

    return null;
  }

  String? _validarDetalhes() {
    if (pago == null) return 'Escolha o tipo de ingresso.';

    if (pago == true) {
      final valor = precoValor;
      if (valor == null || valor <= 0) {
        return 'Informe o preço dos ingressos.';
      }
    }

    for (var i = 0; i < atracoes.length; i++) {
      final atracao = atracoes[i];
      if (atracao.nome.text.trim().isEmpty &&
          atracao.descricao.text.trim().isNotEmpty) {
        return 'Informe o nome da atração ${i + 1}.';
      }
    }

    final temPergunta = pergunta.text.trim().isNotEmpty;
    final temResposta = resposta.text.trim().isNotEmpty;
    if (temPergunta != temResposta) {
      return 'Preencha a pergunta e a resposta, ou deixe as duas vazias.';
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // Envio
  // ---------------------------------------------------------------------------

  /// Corpo para enviar à API. Os nomes dos campos são os do modelo Evento;
  /// ajuste com o pessoal do backend quando o endpoint estiver pronto.
  /// (A imagem de capa precisa de upload à parte, não vai neste JSON.)
  Map<String, dynamic> toJson() {
    final primeira = datas.first;
    final temFaq = pergunta.text.trim().isNotEmpty;

    return {
      'titulo': nome.text.trim(),
      'categoria': categoria,
      'classificacao': classificacao,
      'descricao': descricao.text.trim(),
      'formato': formato,
      'inicio': primeira.inicioCompleto?.toIso8601String(),
      'fim': primeira.fimCompleto?.toIso8601String(),
      'datas': [
        for (final item in datas)
          {
            'inicio': item.inicioCompleto?.toIso8601String(),
            'fim': item.fimCompleto?.toIso8601String(),
          },
      ],
      'local': presencial ? local.text.trim() : null,
      'endereco': presencial ? endereco.text.trim() : null,
      'linkOnline': online ? linkOnline.text.trim() : null,
      'pago': pago,
      'preco': pago == true ? precoValor : 0,
      'linkIngressos': pago == true && linkIngressos.text.trim().isNotEmpty
          ? linkIngressos.text.trim()
          : null,
      'atracoes': [
        for (final atracao in atracoesPreenchidas)
          {
            'nome': atracao.nome.text.trim(),
            'descricao': atracao.descricao.text.trim(),
          },
      ],
      'comodidades': comodidades.toList(),
      'recursosExtras': recursosExtras,
      'informacoesAdicionais': infoAdicionais.text.trim(),
      'faq': temFaq
          ? {
        'pergunta': pergunta.text.trim(),
        'resposta': resposta.text.trim(),
      }
          : null,
    };
  }

  @override
  void dispose() {
    nome.dispose();
    descricao.dispose();
    local.dispose();
    endereco.dispose();
    linkOnline.dispose();
    preco.dispose();
    linkIngressos.dispose();
    infoAdicionais.dispose();
    pergunta.dispose();
    resposta.dispose();

    for (final atracao in atracoes) {
      atracao.dispose();
    }

    super.dispose();
  }
}