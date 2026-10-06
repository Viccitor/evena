import 'dart:convert';

import 'package:evena/components/criar_evento/campos_criar_evento.dart';
import 'package:evena/components/criar_evento/passo_data_local.dart';
import 'package:evena/components/criar_evento/passo_detalhes.dart';
import 'package:evena/components/criar_evento/passo_informacoes.dart';
import 'package:evena/components/criar_evento/passo_revisao.dart';
import 'package:evena/models/rascunho_evento.dart';
import 'package:flutter/material.dart';

class TelaCriarEvento extends StatefulWidget {
  const TelaCriarEvento({super.key});

  @override
  State<TelaCriarEvento> createState() => _TelaCriarEventoState();
}

class _TelaCriarEventoState extends State<TelaCriarEvento> {
  static const List<String> _titulos = [
    'Informações',
    'Data e local',
    'Detalhes',
    'Revisão',
  ];

  static const int _ultimoPasso = 3;

  final RascunhoEvento _rascunho = RascunhoEvento();
  final ScrollController _scroll = ScrollController();

  int _passo = 0;
  bool _publicando = false;

  @override
  void initState() {
    super.initState();
    _rascunho.addListener(_aoMudar);
  }

  void _aoMudar() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _rascunho.removeListener(_aoMudar);
    _rascunho.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  void _irParaPasso(int novoPasso) {
    _rascunho.mostrarErros = false;

    setState(() => _passo = novoPasso);

    if (_scroll.hasClients) {
      _scroll.jumpTo(0);
    }
  }

  void _continuar() {
    final erro = _rascunho.validarPasso(_passo);

    if (erro != null) {
      _rascunho.mostrarErros = true;
      _rascunho.atualizar();
      _mensagem(erro);
      return;
    }

    _irParaPasso(_passo + 1);
  }

  Future<void> _publicar() async {
    final passoComErro = _rascunho.primeiroPassoComErro();

    if (passoComErro != null) {
      final erro = _rascunho.validarPasso(passoComErro)!;

      setState(() => _passo = passoComErro);
      _rascunho.mostrarErros = true;
      _rascunho.atualizar();

      if (_scroll.hasClients) _scroll.jumpTo(0);

      _mensagem(erro);
      return;
    }

    setState(() => _publicando = true);

    // TODO(backend): enviar para a API (ex.: POST /eventos) e fazer o upload
    // da imagem de capa. Por enquanto só mostra o JSON no console.
    debugPrint(const JsonEncoder.withIndent('  ').convert(_rascunho.toJson()));

    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    setState(() => _publicando = false);

    _mensagem('Tudo certo! Falta ligar o envio à API (veja o console).');
  }

  Future<void> _voltarOuSair() async {
    if (_passo > 0) {
      _irParaPasso(_passo - 1);
      return;
    }

    if (!_rascunho.temConteudo) {
      Navigator.pop(context);
      return;
    }

    final sair = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: corCardCriar,
          title: const Text(
            'Descartar evento?',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          content: const Text(
            'O que você preencheu até agora será perdido.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Continuar editando'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Descartar',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (sair == true && mounted) {
      Navigator.pop(context);
    }
  }

  Widget _buildPasso() {
    switch (_passo) {
      case 0:
        return PassoInformacoes(rascunho: _rascunho);
      case 1:
        return PassoDataLocal(rascunho: _rascunho);
      case 2:
        return PassoDetalhes(rascunho: _rascunho);
      default:
        return PassoRevisao(rascunho: _rascunho, onEditar: _irParaPasso);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ultimo = _passo == _ultimoPasso;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _voltarOuSair();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF080427),
        appBar: AppBar(
          backgroundColor: const Color(0xFF01011D),
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _voltarOuSair,
          ),
          title: const Text(
            'Criar novo evento',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: IndicadorPassos(passoAtual: _passo, titulos: _titulos),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scroll,
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: _buildPasso(),
              ),
            ),
            _buildBarraInferior(ultimo),
          ],
        ),
      ),
    );
  }

  Widget _buildBarraInferior(bool ultimo) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: Color(0xFF0B0724),
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_passo > 0)
              OutlinedButton(
                onPressed: _publicando ? null : () => _irParaPasso(_passo - 1),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: corRoxoCriar),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('← Voltar'),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: _publicando ? null : (ultimo ? _publicar : _continuar),
              style: ElevatedButton.styleFrom(
                backgroundColor: corVerdeCriar,
                foregroundColor: corTextoEscuroCriar,
                disabledBackgroundColor: Colors.white12,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                ultimo
                    ? (_publicando ? 'Publicando...' : 'Publicar evento')
                    : 'Continuar →',
              ),
            ),
          ],
        ),
      ),
    );
  }
}