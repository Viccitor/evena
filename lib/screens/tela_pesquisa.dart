import 'package:evena/components/card_evento.dart';
import 'package:evena/data/eventos_data.dart';
import 'package:evena/models/evento.dart';
import 'package:evena/screens/tela_detalhe_evento.dart';
import 'package:flutter/material.dart';

class TelaPesquisa extends StatefulWidget {
  const TelaPesquisa({super.key});

  @override
  State<TelaPesquisa> createState() => _TelaPesquisaState();
}

class _TelaPesquisaState extends State<TelaPesquisa> {
  final _controller = TextEditingController();
  String _termo = '';

  List<Evento> get _resultados {
    final termo = _normalizar(_termo.trim());
    if (termo.isEmpty) return eventos;

    return eventos.where((evento) {
      final alvo = _normalizar(
        '${evento.titulo} ${evento.categoria} ${evento.local} ${evento.endereco} ${evento.formato}',
      );
      return alvo.contains(termo);
    }).toList();
  }

  String _normalizar(String texto) {
    const comAcento = 'áàãâäéèêëíìîïóòõôöúùûüç';
    const semAcento = 'aaaaaeeeeiiiiooooouuuuc';
    var valor = texto.toLowerCase();
    for (var i = 0; i < comAcento.length; i++) {
      valor = valor.replaceAll(comAcento[i], semAcento[i]);
    }
    return valor;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _abrirEvento(Evento evento) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TelaDetalheEvento(evento: evento)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultados = _resultados;

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
                autofocus: true,
                onChanged: (valor) => setState(() => _termo = valor),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Nome, categoria ou local...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF63D13E),
                  ),
                  suffixIcon: _termo.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _controller.clear();
                            setState(() => _termo = '');
                          },
                          icon: const Icon(Icons.close, color: Colors.white54),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    _termo.isEmpty
                        ? 'Todos os eventos'
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
              child: resultados.isEmpty
                  ? const _EstadoVazio()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                      itemCount: resultados.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final evento = resultados[index];
                        return CardEvento(
                          evento: evento,
                          compacto: true,
                          onTap: () => _abrirEvento(evento),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
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
              'Tente pesquisar por outro nome, categoria ou local.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
