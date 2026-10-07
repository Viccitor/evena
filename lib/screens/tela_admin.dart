import 'package:evena/models/evento.dart';
import 'package:evena/services/auth_service.dart';
import 'package:evena/services/evento_service.dart';
import 'package:flutter/material.dart';

class TelaAdmin extends StatefulWidget {
  const TelaAdmin({super.key});

  @override
  State<TelaAdmin> createState() => _TelaAdminState();
}

class _TelaAdminState extends State<TelaAdmin> {
  final EventoService _service = EventoService.instance;
  List<Evento> _eventos = const [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    if (!AuthService.ehAdmin) {
      if (mounted) setState(() => _carregando = false);
      return;
    }

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final eventos = await _service.listarTodosParaAdmin();
      if (mounted) setState(() => _eventos = eventos);
    } catch (e) {
      if (mounted) setState(() => _erro = e.toString());
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _excluir(Evento evento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF140E32),
        title: const Text('Excluir evento?'),
        content: Text(
          'O evento “${evento.titulo}” será removido do banco e deixará de aparecer no app e no site.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await _service.removerEventoAdmin(evento.id);
      await _carregar();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento excluído.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível excluir: $e')),
        );
      }
    }
  }

  Future<void> _editar(Evento evento) async {
    final titulo = TextEditingController(text: evento.titulo);
    final descricao = TextEditingController(text: evento.descricao);
    final preco = TextEditingController(
      text: evento.preco == null ? '' : evento.preco!.toStringAsFixed(2),
    );
    final link = TextEditingController(text: evento.linkIngressos ?? '');
    var classificacao = evento.classificacao.isEmpty ? 'Livre' : evento.classificacao;
    var ativo = evento.ativo;
    var salvando = false;

    final atualizado = await showDialog<Evento>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> salvar() async {
              if (titulo.text.trim().isEmpty || descricao.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Título e descrição são obrigatórios.')),
                );
                return;
              }

              setDialogState(() => salvando = true);
              try {
                final valorPreco = double.tryParse(
                  preco.text.trim().replaceAll(',', '.'),
                );
                final resultado = await _service.editarEventoAdmin(
                  evento: evento,
                  titulo: titulo.text,
                  descricao: descricao.text,
                  classificacao: classificacao,
                  preco: valorPreco,
                  link: link.text,
                  ativo: ativo,
                );
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext, resultado);
                }
              } catch (e) {
                setDialogState(() => salvando = false);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Não foi possível salvar: $e')),
                  );
                }
              }
            }

            return AlertDialog(
              backgroundColor: const Color(0xFF140E32),
              title: const Text('Editar evento'),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titulo,
                        decoration: const InputDecoration(labelText: 'Título'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descricao,
                        maxLines: 4,
                        decoration: const InputDecoration(labelText: 'Descrição'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: classificacao,
                        decoration: const InputDecoration(labelText: 'Classificação'),
                        items: const ['Livre', '10', '12', '14', '16', '18']
                            .map((valor) => DropdownMenuItem(
                          value: valor,
                          child: Text(valor),
                        ))
                            .toList(),
                        onChanged: salvando
                            ? null
                            : (valor) {
                          if (valor != null) {
                            setDialogState(() => classificacao = valor);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: preco,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Preço'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: link,
                        decoration: const InputDecoration(labelText: 'Link'),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Evento ativo'),
                        value: ativo,
                        activeThumbColor: const Color(0xFF00FF00),
                        onChanged: salvando
                            ? null
                            : (valor) => setDialogState(() => ativo = valor),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: salvando ? null : () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: salvando ? null : salvar,
                  child: Text(salvando ? 'Salvando...' : 'Salvar'),
                ),
              ],
            );
          },
        );
      },
    );

    titulo.dispose();
    descricao.dispose();
    preco.dispose();
    link.dispose();

    if (atualizado != null) {
      await _carregar();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento atualizado.')),
        );
      }
    }
  }

  Widget _imagem(Evento evento) {
    if (evento.imagemUrl.startsWith('http://') ||
        evento.imagemUrl.startsWith('https://')) {
      return Image.network(
        evento.imagemUrl,
        width: 76,
        height: 76,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackImagem(),
      );
    }
    return _fallbackImagem();
  }

  Widget _fallbackImagem() {
    return Container(
      width: 76,
      height: 76,
      color: const Color(0xFF251660),
      child: const Icon(Icons.event_rounded, color: Colors.white38),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.ehAdmin) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Acesso restrito a administradores.',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF00FF00)),
      );
    }

    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_erro!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _carregar,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
        children: [
          const Text(
            'Administração',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_eventos.length} evento(s) no banco',
            style: const TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 16),
          for (final evento in _eventos)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF140E32),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _imagem(evento),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          evento.titulo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '#${evento.id} • ${evento.ativo ? 'Ativo' : 'Inativo'}',
                          style: TextStyle(
                            color: evento.ativo
                                ? const Color(0xFF00FF00)
                                : Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _editar(evento),
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              label: const Text('Editar'),
                            ),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                                side: const BorderSide(color: Colors.redAccent),
                              ),
                              onPressed: () => _excluir(evento),
                              icon: const Icon(Icons.delete_outline_rounded, size: 16),
                              label: const Text('Excluir'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
