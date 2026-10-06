import 'package:evena/models/evento.dart';
import 'package:evena/models/perfil.dart';
import 'package:evena/models/rascunho_evento.dart';
import 'package:evena/services/api_service.dart';
import 'package:flutter/foundation.dart';

class EventoService extends ChangeNotifier {
  EventoService._();

  static final EventoService instance = EventoService._();

  final List<Evento> _eventos = [];
  bool _carregando = false;
  String? _erro;

  List<Evento> get eventos => List.unmodifiable(_eventos);
  bool get carregando => _carregando;
  String? get erro => _erro;

  Future<void> carregar() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      final data = await ApiService.get('/eventos/ativos') as List<dynamic>;
      _eventos
        ..clear()
        ..addAll(
          data.map((item) => Evento.fromJson(item as Map<String, dynamic>)),
        );
    } on ApiException catch (erro) {
      _erro = erro.mensagem;
    } catch (_) {
      _erro = 'Não foi possível conectar com a API.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<Evento> publicar({
    required RascunhoEvento rascunho,
    required Perfil perfil,
  }) async {
    final empresaId = await _obterOuCriarEmpresa(
      perfil: perfil,
      rascunho: rascunho,
    );

    final capa = rascunho.capa;
    if (capa == null) {
      throw const ApiException('Escolha a imagem de capa.');
    }

    final upload = await ApiService.uploadFile(
      '/arquivos/imagens',
      arquivo: capa,
    ) as Map<String, dynamic>;

    final capaUrl = upload['url']?.toString();
    if (capaUrl == null || capaUrl.isEmpty) {
      throw const ApiException('A API não retornou a URL da imagem.');
    }

    final linkIngressos = rascunho.linkIngressos.text.trim();
    final linkOnline = rascunho.linkOnline.text.trim();
    final link = rascunho.online && linkOnline.isNotEmpty
        ? linkOnline
        : (linkIngressos.isNotEmpty ? linkIngressos : null);

    final criado = await ApiService.post(
      '/empresas/$empresaId/eventos',
      body: {
        'titulo': rascunho.nome.text.trim(),
        'status': true,
        'classificacao': rascunho.classificacao,
        'banner': capaUrl,
        'capa': capaUrl,
        'descricao': rascunho.descricao.text.trim(),
        'preco': rascunho.pago == true ? rascunho.precoValor : 0,
        'link': link,
      },
    ) as Map<String, dynamic>;

    final eventoId = _idComoInt(criado['id']);

    for (final item in rascunho.datas) {
      final inicio = item.inicioCompleto;
      if (inicio == null) continue;

      await ApiService.post(
        '/eventos/$eventoId/datas',
        body: {'dataHora': inicio.toIso8601String()},
      );
    }

    if (rascunho.presencial) {
      await ApiService.post(
        '/localizacoes',
        body: {
          'eventoId': eventoId,
          'endereco': rascunho.endereco.text.trim(),
          'nomeEstabelecimento': rascunho.local.text.trim(),
        },
      );
    }

    int? primeiroArtistaId;

    for (final atracao in rascunho.atracoesPreenchidas) {
      final artista = await ApiService.post(
        '/artistas',
        body: {
          'nome': atracao.nome.text.trim(),
          'obras': atracao.descricao.text.trim().isEmpty
              ? null
              : atracao.descricao.text.trim(),
          'foto': null,
        },
      ) as Map<String, dynamic>;

      final artistaId = _idComoInt(artista['id']);
      primeiroArtistaId ??= artistaId;

      await ApiService.post('/eventos/$eventoId/artistas/$artistaId');
    }

    if (rascunho.categoria != null) {
      await ApiService.post(
        '/categorias',
        body: {
          'eventoId': eventoId,
          'artistaId': primeiroArtistaId,
          'tipo': rascunho.categoria,
          'estilo': null,
          'foto': capaUrl,
        },
      );
    }

    final atualizado = await ApiService.get('/eventos/$eventoId')
        as Map<String, dynamic>;
    final evento = Evento.fromJson(atualizado);

    final indice = _eventos.indexWhere((item) => item.id == evento.id);
    if (indice >= 0) {
      _eventos[indice] = evento;
    } else {
      _eventos.insert(0, evento);
    }
    notifyListeners();

    return evento;
  }

  Future<int> _obterOuCriarEmpresa({
    required Perfil perfil,
    required RascunhoEvento rascunho,
  }) async {
    final empresas = await ApiService.get('/empresas') as List<dynamic>;

    for (final item in empresas) {
      if (item is! Map<String, dynamic>) continue;

      final perfilEmpresa = item['perfil'];
      if (perfilEmpresa is Map<String, dynamic>) {
        final perfilId = _idOpcional(perfilEmpresa['id']);
        if (perfilId == perfil.id) {
          return _idComoInt(item['id']);
        }
      }
    }

    final empresa = await ApiService.post(
      '/empresas',
      body: {
        'perfilId': perfil.id,
        'cnpj': null,
        'nome': '${perfil.nome.trim()} Eventos',
        'endereco': rascunho.presencial
            ? rascunho.endereco.text.trim()
            : null,
        'setor': rascunho.categoria ?? 'Eventos',
      },
    ) as Map<String, dynamic>;

    return _idComoInt(empresa['id']);
  }

  int _idComoInt(dynamic valor) {
    final id = _idOpcional(valor);
    if (id == null) {
      throw const ApiException('A API não retornou o identificador esperado.');
    }
    return id;
  }

  int? _idOpcional(dynamic valor) {
    if (valor is int) return valor;
    return int.tryParse(valor?.toString() ?? '');
  }

  List<Evento> pesquisar(String termo, {String? categoria}) {
    final busca = _normalizar(termo.trim());
    final filtroCategoria =
        categoria == null ? '' : _normalizar(categoria.trim());

    return _eventos.where((evento) {
      if (filtroCategoria.isNotEmpty &&
          _normalizar(evento.categoria.trim()) != filtroCategoria) {
        return false;
      }

      if (busca.isEmpty) return true;

      final textoCompleto = _normalizar(
        '${evento.titulo} ${evento.categoria} ${evento.local} ${evento.endereco} ${evento.descricao} ${evento.formato}',
      );

      return textoCompleto.contains(busca);
    }).toList();
  }

  String _normalizar(String texto) {
    var valor = texto.toLowerCase();

    const comAcento = 'áàãâäéèêëíìîïóòõôöúùûüç';
    const semAcento = 'aaaaaeeeeiiiiooooouuuuc';

    for (var i = 0; i < semAcento.length; i++) {
      if (i < comAcento.length) {
        valor = valor.replaceAll(comAcento[i], semAcento[i]);
      }
    }

    return valor;
  }
}
