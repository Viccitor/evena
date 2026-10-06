import 'package:flutter/material.dart';
import 'package:evena/components/card_evento.dart';
import 'package:evena/data/categorias_data.dart';
import 'package:evena/models/evento.dart';
import 'package:evena/screens/tela_detalhe_evento.dart';
import 'package:evena/services/evento_service.dart';

class TelaPesquisa extends StatefulWidget {
  /// Se informada, a tela já abre com essa categoria filtrada.
  final String? categoriaInicial;

  const TelaPesquisa({super.key, this.categoriaInicial});

  @override
  State<TelaPesquisa> createState() => _TelaPesquisaState();
}

class _TelaPesquisaState extends State<TelaPesquisa> {
  final _controller = TextEditingController();
  final _service = EventoService.instance;

  String? _categoria;

  // Chaves para rolar a fila de chips até a categoria selecionada.
  final Map<String, GlobalKey> _chaves = {
    for (final categoria in categoriasEventos) categoria.nome: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _categoria = widget.categoriaInicial;
    _controller.addListener(_onRebuild);
    _service.addListener(_onRebuild);

    // Carrega os eventos da API se a lista estiver vazia
    if (_service.eventos.isEmpty) {
      _service.carregar();
    }

    _rolarAteCategoria();
  }

  void _onRebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onRebuild);
    _service.removeListener(_onRebuild);
    _controller.dispose();
    super.dispose();
  }

  void _rolarAteCategoria() {
    final nome = _categoria;
    if (nome == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contexto = _chaves[nome]?.currentContext;

      if (contexto != null) {
        Scrollable.ensureVisible(
          contexto,
          alignment: .5,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _abrirEvento(Evento evento) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TelaDetalheEvento(evento: evento)),
    );
  }

  Widget _buildCategorias() {
    const verde = Color(0xFF63D13E);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final categoria in categoriasEventos)
            Padding(
              key: _chaves[categoria.nome],
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(categoria.nome),
                selected: _categoria == categoria.nome,
                showCheckmark: false,
                backgroundColor: const Color(0xFF140E32),
                selectedColor: verde,
                side: BorderSide(
                  color: _categoria == categoria.nome
                      ? verde
                      : const Color(0xFF7C2BDC).withValues(alpha: .35),
                ),
                labelStyle: TextStyle(
                  color: _categoria == categoria.nome
                      ? const Color(0xFF071008)
                      : Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                onSelected: (selecionada) {
                  setState(() {
                    _categoria = selecionada ? categoria.nome : null;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final termo = _controller.text;
    final resultados = _service.pesquisar(termo, categoria: _categoria);
    final semFiltros = termo.isEmpty && _categoria == null;

    return Scaffold(
      backgroundColor: const Color(0xFF080427),
      appBar: AppBar(
        backgroundColor: const Color(0xFF01011D),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Pesquisar eventos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
              child: TextField(
                controller: _controller,
                // Não abre o teclado quando veio de uma categoria.
                autofocus: widget.categoriaInicial == null,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Nome, categoria ou local...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF63D13E),
                  ),
                  suffixIcon: termo.isNotEmpty
                      ? IconButton(
                    onPressed: () => _controller.clear(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white54,
                    ),
                  )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFF140E32),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF63D13E)),
                  ),
                ),
              ),
            ),
            _buildCategorias(),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    semFiltros
                        ? 'Todos os eventos (${resultados.length})'
                        : '${resultados.length} resultado(s)',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _service.carregando && _service.eventos.isEmpty
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF63D13E),
                ),
              )
                  : resultados.isEmpty
                  ? const _EstadoVazio()
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                itemCount: resultados.length,
                itemBuilder: (context, index) {
                  final evento = resultados[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CardEvento(
                      evento: evento,
                      compacto: true,
                      onTap: () => _abrirEvento(evento),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  const _EstadoVazio();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 56, color: Colors.white30),
            SizedBox(height: 14),
            Text(
              'Nenhum evento encontrado',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Tente outra categoria, nome ou local.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}