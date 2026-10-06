import 'dart:io';

import 'package:evena/components/card_comodidade.dart';
import 'package:evena/components/criar_evento/campos_criar_evento.dart';
import 'package:evena/components/secao_compra_evento.dart';
import 'package:evena/models/rascunho_evento.dart';
import 'package:flutter/material.dart';

class PassoRevisao extends StatelessWidget {
  final RascunhoEvento rascunho;

  /// Recebe o índice do passo (0, 1 ou 2) para voltar e editar.
  final ValueChanged<int> onEditar;

  const PassoRevisao({
    super.key,
    required this.rascunho,
    required this.onEditar,
  });

  String? _classificacao() {
    final valor = rascunho.classificacao;
    if (valor == null) return null;
    return valor == 'Livre' ? 'Livre' : '$valor anos';
  }

  String _horario(DataRascunho item) {
    final inicio = item.inicio;
    if (inicio == null) return '';

    final fim = item.fim;
    if (fim == null) return formatarHora(inicio);

    return '${formatarHora(inicio)} – ${formatarHora(fim)}';
  }

  String _ingressos() {
    final pago = rascunho.pago;
    if (pago == null) return '';
    if (!pago) return 'Gratuito';

    final preco = formatarPreco(rascunho.precoValor);
    final link = rascunho.linkIngressos.text.trim();

    return link.isEmpty ? 'Pago · a partir de $preco' : 'Pago · a partir de $preco\n$link';
  }

  String _visitantes() {
    final nomes = <String>[
      for (final comodidade in comodidadesCatalogo)
        if (rascunho.comodidades.contains(comodidade.chave)) comodidade.titulo,
      ...rascunho.recursosExtras,
    ];

    return nomes.isEmpty ? 'Nenhum recurso informado' : nomes.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final atracoes = rascunho.atracoesPreenchidas;
    final temFaq = rascunho.pergunta.text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Revise seu evento',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Confira todas as informações antes de publicar seu evento.',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
        const SizedBox(height: 16),

        // --- INFORMAÇÕES BÁSICAS ---
        _BlocoRevisao(
          titulo: 'Informações básicas',
          onEditar: () => onEditar(0),
          children: [
            _ItemRevisao('Nome', rascunho.nome.text),
            _ItemRevisao('Categoria', rascunho.categoria),
            _ItemRevisao('Classificação', _classificacao()),
            _ItemRevisao('Descrição', rascunho.descricao.text),
            _CapaRevisao(capa: rascunho.capa),
          ],
        ),
        const SizedBox(height: 14),

        // --- DATA E LOCAL ---
        _BlocoRevisao(
          titulo: 'Data e local',
          onEditar: () => onEditar(1),
          children: [
            for (var i = 0; i < rascunho.datas.length; i++)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: corCampoCriar,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _ItemRevisao(
                        'Data ${i + 1}',
                        rascunho.datas[i].data == null
                            ? null
                            : formatarDataCurta(rascunho.datas[i].data!),
                        espaco: false,
                      ),
                    ),
                    Expanded(
                      child: _ItemRevisao(
                        'Horário',
                        _horario(rascunho.datas[i]),
                        espaco: false,
                      ),
                    ),
                  ],
                ),
              ),
            _ItemRevisao('Tipo', rascunho.formato),
            if (rascunho.presencial) ...[
              _ItemRevisao('Local', rascunho.local.text),
              _ItemRevisao('Endereço', rascunho.endereco.text),
            ],
            if (rascunho.online)
              _ItemRevisao('Link do evento', rascunho.linkOnline.text),
          ],
        ),
        const SizedBox(height: 14),

        // --- DETALHES ---
        _BlocoRevisao(
          titulo: 'Detalhes',
          onEditar: () => onEditar(2),
          children: [
            _ItemRevisao('Ingressos', _ingressos()),
            _ItemRevisao(
              'Atrações',
              atracoes.isEmpty
                  ? 'Nenhuma atração informada'
                  : atracoes
                  .map((a) {
                final descricao = a.descricao.text.trim();
                final nome = a.nome.text.trim();
                return descricao.isEmpty ? nome : '$nome — $descricao';
              })
                  .join('\n'),
            ),
            _ItemRevisao('Informações para visitantes', _visitantes()),
            _ItemRevisao(
              'Informações adicionais',
              rascunho.infoAdicionais.text,
            ),
            if (temFaq)
              _ItemRevisao(
                'Pergunta frequente',
                '${rascunho.pergunta.text.trim()}\n'
                    '${rascunho.resposta.text.trim()}',
              ),
          ],
        ),
      ],
    );
  }
}

class _BlocoRevisao extends StatelessWidget {
  final String titulo;
  final VoidCallback onEditar;
  final List<Widget> children;

  const _BlocoRevisao({
    required this.titulo,
    required this.onEditar,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: corCardCriar,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: corRoxoCriar.withValues(alpha: .28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton(
                onPressed: onEditar,
                style: TextButton.styleFrom(
                  foregroundColor: corVerdeCriar,
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('Editar'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _ItemRevisao extends StatelessWidget {
  final String rotulo;
  final String? valor;
  final bool espaco;

  const _ItemRevisao(this.rotulo, this.valor, {this.espaco = true});

  @override
  Widget build(BuildContext context) {
    final texto = (valor ?? '').trim();
    final vazio = texto.isEmpty;

    return Padding(
      padding: EdgeInsets.only(bottom: espaco ? 14 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rotulo,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 3),
          Text(
            vazio ? 'Não informado' : texto,
            style: TextStyle(
              color: vazio ? Colors.white38 : Colors.white,
              fontSize: 14,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CapaRevisao extends StatelessWidget {
  final File? capa;

  const _CapaRevisao({required this.capa});

  @override
  Widget build(BuildContext context) {
    final arquivo = capa;

    if (arquivo == null) {
      return const _ItemRevisao('Imagem de capa', 'Não selecionada');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Imagem de capa',
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            arquivo,
            width: 140,
            height: 84,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}