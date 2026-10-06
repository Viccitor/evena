import 'dart:io';

import 'package:evena/components/criar_evento/campos_criar_evento.dart';
import 'package:evena/data/categorias_data.dart';
import 'package:evena/models/rascunho_evento.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PassoInformacoes extends StatelessWidget {
  final RascunhoEvento rascunho;

  const PassoInformacoes({super.key, required this.rascunho});

  static const int _limiteBytes = 5 * 1024 * 1024; // 5 MB

  String? _obrigatorio(String texto) {
    return rascunho.mostrarErros && texto.trim().isEmpty
        ? 'Campo obrigatório'
        : null;
  }

  void _mensagem(BuildContext context, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _escolherCapa(BuildContext context) async {
    final picker = ImagePicker();
    final arquivo = await picker.pickImage(source: ImageSource.gallery);

    if (arquivo == null) return;

    final caminho = arquivo.path.toLowerCase();
    final formatoValido = ['.jpg', '.jpeg', '.png', '.gif'].any(
      caminho.endsWith,
    );

    if (!formatoValido) {
      if (context.mounted) {
        _mensagem(context, 'Use uma imagem JPG, PNG ou GIF.');
      }
      return;
    }

    final tamanho = await arquivo.length();

    if (tamanho > _limiteBytes) {
      if (context.mounted) {
        _mensagem(context, 'A imagem deve ter até 5 MB.');
      }
      return;
    }

    rascunho.capa = File(arquivo.path);
    rascunho.atualizar();
  }

  @override
  Widget build(BuildContext context) {
    final erroCategoria = rascunho.mostrarErros && rascunho.categoria == null;
    final erroClassificacao =
        rascunho.mostrarErros && rascunho.classificacao == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CampoCriarEvento(
          rotulo: 'Nome do evento',
          obrigatorio: true,
          hint: 'Ex: Festival Conexão',
          controller: rascunho.nome,
          errorText: _obrigatorio(rascunho.nome.text),
          aoDigitar: rascunho.aoDigitar,
        ),
        const SizedBox(height: 20),

        // --- CATEGORIA ---
        const RotuloCampo(texto: 'Categoria', obrigatorio: true),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: decoracaoCampo(
            errorText: erroCategoria ? 'Selecione uma categoria' : null,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: rascunho.categoria,
              isExpanded: true,
              isDense: true,
              dropdownColor: corCardCriar,
              iconEnabledColor: Colors.white70,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              hint: const Text(
                'Selecione uma categoria',
                style: TextStyle(color: Colors.white38, fontSize: 14),
              ),
              items: [
                for (final categoria in categoriasEventos)
                  DropdownMenuItem(
                    value: categoria.nome,
                    child: Text(categoria.nome),
                  ),
              ],
              onChanged: (valor) {
                rascunho.categoria = valor;
                rascunho.atualizar();
              },
            ),
          ),
        ),
        const SizedBox(height: 20),

        // --- CLASSIFICAÇÃO ETÁRIA ---
        const RotuloCampo(texto: 'Classificação etária', obrigatorio: true),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final valor in classificacoesEvento)
              _ChipClassificacao(
                texto: valor,
                selecionado: rascunho.classificacao == valor,
                onTap: () {
                  rascunho.classificacao = valor;
                  rascunho.atualizar();
                },
              ),
          ],
        ),
        TextoErroCampo(erroClassificacao ? 'Selecione a classificação' : null),
        const SizedBox(height: 20),

        CampoCriarEvento(
          rotulo: 'Descrição do evento',
          obrigatorio: true,
          hint: 'Conte um pouco sobre o evento, atrações e o que o público '
              'pode esperar...',
          controller: rascunho.descricao,
          maxLines: 5,
          maxLength: 500,
          errorText: _obrigatorio(rascunho.descricao.text),
          aoDigitar: rascunho.aoDigitar,
        ),
        const SizedBox(height: 12),

        // --- IMAGEM DE CAPA ---
        const RotuloCampo(texto: 'Imagem de capa', obrigatorio: true),
        const SizedBox(height: 8),
        _buildCapa(context),
        TextoErroCampo(
          rascunho.mostrarErros && rascunho.capa == null
              ? 'Escolha a imagem de capa'
              : null,
        ),
      ],
    );
  }

  Widget _buildCapa(BuildContext context) {
    final capa = rascunho.capa;
    final comErro = rascunho.mostrarErros && capa == null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: corCampoCriar,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: comErro
              ? Colors.redAccent
              : corRoxoCriar.withValues(alpha: .4),
        ),
      ),
      child: capa == null
          ? Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.arrow_upward_rounded,
              color: corVerdeCriar,
              size: 32,
            ),
            const SizedBox(height: 10),
            const Text(
              'Escolha uma imagem',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'JPG, PNG ou GIF · até 5 MB',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
            const SizedBox(height: 14),
            BotaoAdicionar(
              texto: 'Escolher arquivo',
              onPressed: () => _escolherCapa(context),
            ),
          ],
        ),
      )
          : ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          children: [
            Image.file(
              capa,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: [
                  _BotaoCapa(
                    icone: Icons.edit_outlined,
                    dica: 'Trocar imagem',
                    onTap: () => _escolherCapa(context),
                  ),
                  const SizedBox(width: 8),
                  _BotaoCapa(
                    icone: Icons.delete_outline_rounded,
                    dica: 'Remover imagem',
                    onTap: () {
                      rascunho.capa = null;
                      rascunho.atualizar();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipClassificacao extends StatelessWidget {
  final String texto;
  final bool selecionado;
  final VoidCallback onTap;

  const _ChipClassificacao({
    required this.texto,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selecionado ? corVerdeCriar : corCampoCriar,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 52,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selecionado
                  ? corVerdeCriar
                  : corRoxoCriar.withValues(alpha: .35),
            ),
          ),
          child: Text(
            texto,
            style: TextStyle(
              color: selecionado ? corTextoEscuroCriar : Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _BotaoCapa extends StatelessWidget {
  final IconData icone;
  final String dica;
  final VoidCallback onTap;

  const _BotaoCapa({
    required this.icone,
    required this.dica,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: dica,
      child: Material(
        color: Colors.black.withValues(alpha: .65),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icone, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }
}