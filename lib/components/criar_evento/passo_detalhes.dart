import 'package:evena/components/card_comodidade.dart';
import 'package:evena/components/criar_evento/campos_criar_evento.dart';
import 'package:evena/models/rascunho_evento.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PassoDetalhes extends StatelessWidget {
  final RascunhoEvento rascunho;

  const PassoDetalhes({super.key, required this.rascunho});

  Future<void> _adicionarRecurso(BuildContext context) async {
    final controller = TextEditingController();

    final nome = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: corCardCriar,
          title: const Text(
            'Adicionar recurso',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: decoracaoCampo(hint: 'Ex: Área de descanso'),
            onSubmitted: (valor) => Navigator.pop(dialogContext, valor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, controller.text),
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );

    final texto = nome?.trim() ?? '';
    if (texto.isEmpty) return;

    if (!rascunho.recursosExtras.contains(texto)) {
      rascunho.recursosExtras.add(texto);
      rascunho.atualizar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIngressos(),
        const SizedBox(height: 16),
        _buildAtracoes(),
        const SizedBox(height: 16),
        _buildVisitantes(context),
        const SizedBox(height: 16),
        _buildPerguntas(),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Ingressos
  // ---------------------------------------------------------------------------

  Widget _buildIngressos() {
    final erroTipo = rascunho.mostrarErros && rascunho.pago == null;
    final valor = rascunho.precoValor;
    final erroPreco =
        rascunho.mostrarErros && (valor == null || valor <= 0);

    return SecaoCriarEvento(
      titulo: 'Ingressos',
      subtitulo: 'Defina como será o acesso ao seu evento.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RotuloCampo(texto: 'Tipo de ingresso', obrigatorio: true),
          const SizedBox(height: 8),
// Adicione o IntrinsicHeight em volta da Row
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: OpcaoSelecionavel(
                    titulo: 'Gratuito',
                    subtitulo: 'Entrada livre',
                    selecionado: rascunho.pago == false,
                    onTap: () {
                      rascunho.pago = false;
                      rascunho.atualizar();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OpcaoSelecionavel(
                    titulo: 'Pago',
                    subtitulo: 'Venda de ingressos',
                    selecionado: rascunho.pago == true,
                    onTap: () {
                      rascunho.pago = true;
                      rascunho.atualizar();
                    },
                  ),
                ),
              ],
            ),
          ),

          TextoErroCampo(erroTipo ? 'Escolha o tipo de ingresso' : null),
          if (rascunho.pago == true) ...[
            const SizedBox(height: 16),
            CampoCriarEvento(
              rotulo: 'Preço a partir de',
              obrigatorio: true,
              hint: 'Ex: 150,00',
              prefixText: 'R\$ ',
              controller: rascunho.preco,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
              ],
              errorText: erroPreco ? 'Informe um preço válido' : null,
              aoDigitar: rascunho.aoDigitar,
            ),
            const SizedBox(height: 16),
            CampoCriarEvento(
              rotulo: 'Link para compra de ingressos (opcional)',
              hint: 'https://...',
              controller: rascunho.linkIngressos,
              keyboardType: TextInputType.url,
              aoDigitar: rascunho.aoDigitar,
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Atrações
  // ---------------------------------------------------------------------------

  Widget _buildAtracoes() {
    return SecaoCriarEvento(
      titulo: 'Atrações',
      subtitulo: 'Adicione as principais atrações do evento.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < rascunho.atracoes.length; i++) ...[
            _buildAtracao(i),
            const SizedBox(height: 12),
          ],
          BotaoAdicionar(
            texto: '+ Adicionar atração',
            onPressed: () {
              rascunho.atracoes.add(AtracaoRascunho());
              rascunho.atualizar();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAtracao(int indice) {
    final atracao = rascunho.atracoes[indice];
    final erroNome = rascunho.mostrarErros &&
        atracao.nome.text.trim().isEmpty &&
        atracao.descricao.text.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: corCampoCriar,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: corRoxoCriar.withValues(alpha: .25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Atração ${indice + 1}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (rascunho.atracoes.length > 1)
                InkWell(
                  onTap: () {
                    rascunho.atracoes.removeAt(indice).dispose();
                    rascunho.atualizar();
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white54,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          CampoCriarEvento(
            rotulo: 'Nome da atração',
            hint: 'Ex: Banda, artista ou palestrante',
            controller: atracao.nome,
            errorText: erroNome ? 'Informe o nome da atração' : null,
            aoDigitar: rascunho.aoDigitar,
          ),
          const SizedBox(height: 14),
          CampoCriarEvento(
            rotulo: 'Descrição',
            hint: 'Descreva a atração...',
            controller: atracao.descricao,
            maxLines: 3,
            aoDigitar: rascunho.aoDigitar,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Informações para visitantes
  // ---------------------------------------------------------------------------

  Widget _buildVisitantes(BuildContext context) {
    return SecaoCriarEvento(
      titulo: 'Informações para visitantes',
      subtitulo: 'Informe recursos disponíveis no local.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final comodidade in comodidadesCatalogo)
                _buildChipComodidade(comodidade),
              for (final extra in rascunho.recursosExtras)
                InputChip(
                  label: Text(extra),
                  onDeleted: () {
                    rascunho.recursosExtras.remove(extra);
                    rascunho.atualizar();
                  },
                  deleteIconColor: Colors.white70,
                  backgroundColor: corVerdeCriar.withValues(alpha: .15),
                  side: const BorderSide(color: corVerdeCriar),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          BotaoAdicionar(
            texto: '+ Adicionar recurso',
            onPressed: () => _adicionarRecurso(context),
          ),
          const SizedBox(height: 18),
          CampoCriarEvento(
            rotulo: 'Informações adicionais',
            hint: 'Adicione outras informações importantes para os '
                'visitantes...',
            controller: rascunho.infoAdicionais,
            maxLines: 4,
            aoDigitar: rascunho.aoDigitar,
          ),
        ],
      ),
    );
  }

  Widget _buildChipComodidade(Comodidade comodidade) {
    final selecionada = rascunho.comodidades.contains(comodidade.chave);

    return FilterChip(
      avatar: Icon(
        comodidade.icone,
        size: 16,
        color: selecionada ? corTextoEscuroCriar : Colors.white70,
      ),
      label: Text(comodidade.titulo),
      selected: selecionada,
      showCheckmark: false,
      backgroundColor: corCampoCriar,
      selectedColor: corVerdeCriar,
      side: BorderSide(
        color: selecionada
            ? corVerdeCriar
            : corRoxoCriar.withValues(alpha: .35),
      ),
      labelStyle: TextStyle(
        color: selecionada ? corTextoEscuroCriar : Colors.white70,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      onSelected: (marcada) {
        if (marcada) {
          rascunho.comodidades.add(comodidade.chave);
        } else {
          rascunho.comodidades.remove(comodidade.chave);
        }
        rascunho.atualizar();
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Perguntas frequentes
  // ---------------------------------------------------------------------------

  Widget _buildPerguntas() {
    final temPergunta = rascunho.pergunta.text.trim().isNotEmpty;
    final temResposta = rascunho.resposta.text.trim().isNotEmpty;

    return SecaoCriarEvento(
      titulo: 'Perguntas frequentes',
      subtitulo: 'Adicione uma pergunta e resposta para os visitantes.',
      child: Column(
        children: [
          CampoCriarEvento(
            rotulo: 'Pergunta',
            hint: 'Ex: O evento possui estacionamento?',
            controller: rascunho.pergunta,
            errorText: rascunho.mostrarErros && temResposta && !temPergunta
                ? 'Informe a pergunta'
                : null,
            aoDigitar: rascunho.aoDigitar,
          ),
          const SizedBox(height: 14),
          CampoCriarEvento(
            rotulo: 'Resposta',
            hint: 'Informe a resposta...',
            controller: rascunho.resposta,
            maxLines: 4,
            errorText: rascunho.mostrarErros && temPergunta && !temResposta
                ? 'Informe a resposta'
                : null,
            aoDigitar: rascunho.aoDigitar,
          ),
        ],
      ),
    );
  }
}