import 'dart:io';

import 'package:evena/components/criar_evento/campos_criar_evento.dart';
import 'package:evena/data/categorias_data.dart';
import 'package:evena/models/rascunho_evento.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PassoInformacoes extends StatefulWidget {
  final RascunhoEvento rascunho;

  const PassoInformacoes({super.key, required this.rascunho});

  @override
  State<PassoInformacoes> createState() => _PassoInformacoesState();
}

class _PassoInformacoesState extends State<PassoInformacoes> {
  static const int _limiteBytes = 5 * 1024 * 1024;
  static const String _pastaCapas = 'assets/images/capas_predefinidas/';

  List<String> _capasPredefinidas = const [];

  RascunhoEvento get rascunho => widget.rascunho;

  @override
  void initState() {
    super.initState();
    _carregarCapasPredefinidas();
  }

  Future<void> _carregarCapasPredefinidas() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final capas = manifest
          .listAssets()
          .where((asset) => asset.startsWith(_pastaCapas))
          .where(_ehImagem)
          .toList()
        ..sort();

      if (mounted) setState(() => _capasPredefinidas = capas);
    } catch (_) {
      if (mounted) setState(() => _capasPredefinidas = const []);
    }
  }

  bool _ehImagem(String caminho) {
    final valor = caminho.toLowerCase();
    return valor.endsWith('.jpg') ||
        valor.endsWith('.jpeg') ||
        valor.endsWith('.png') ||
        valor.endsWith('.webp') ||
        valor.endsWith('.gif');
  }

  String? _obrigatorio(String texto) {
    return rascunho.mostrarErros && texto.trim().isEmpty
        ? 'Campo obrigatório'
        : null;
  }

  void _mensagem(BuildContext context, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _tirarFoto(BuildContext context) async {
    final picker = ImagePicker();
    final arquivo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 88,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (arquivo == null) return;

    final tamanho = await arquivo.length();
    if (tamanho > _limiteBytes) {
      if (context.mounted) {
        _mensagem(context, 'A imagem deve ter até 5 MB.');
      }
      return;
    }

    rascunho.definirCapaArquivo(File(arquivo.path));
  }

  Future<void> _escolherPredefinida(BuildContext context) async {
    if (_capasPredefinidas.isEmpty) {
      _mensagem(
        context,
        'Nenhuma imagem predefinida foi encontrada na pasta de capas.',
      );
      return;
    }

    final escolhida = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF140E32),
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Escolha uma capa pronta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Essas imagens ficam dentro do próprio Evena. Nenhuma galeria do celular é aberta.',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: MediaQuery.of(sheetContext).size.height * .48,
                  child: GridView.builder(
                    itemCount: _capasPredefinidas.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 16 / 10,
                    ),
                    itemBuilder: (_, index) {
                      final asset = _capasPredefinidas[index];
                      return Material(
                        color: Colors.transparent,
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () => Navigator.pop(sheetContext, asset),
                          child: Ink.image(
                            image: AssetImage(asset),
                            fit: BoxFit.cover,
                            child: const Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Color(0xCC080427),
                                  child: Icon(
                                    Icons.check_rounded,
                                    size: 18,
                                    color: Color(0xFF00FF00),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (escolhida != null) {
      rascunho.definirCapaAsset(escolhida);
    }
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
          hint: 'Conte um pouco sobre o evento, atrações e o que o público pode esperar...',
          controller: rascunho.descricao,
          maxLines: 5,
          maxLength: 500,
          errorText: _obrigatorio(rascunho.descricao.text),
          aoDigitar: rascunho.aoDigitar,
        ),
        const SizedBox(height: 12),
        const RotuloCampo(texto: 'Imagem de capa', obrigatorio: true),
        const SizedBox(height: 8),
        _buildCapa(context),
        TextoErroCampo(
          rascunho.mostrarErros && !rascunho.temCapa
              ? 'Escolha a imagem de capa'
              : null,
        ),
      ],
    );
  }

  Widget _buildCapa(BuildContext context) {
    final arquivo = rascunho.capa;
    final asset = rascunho.capaAsset;
    final comErro = rascunho.mostrarErros && !rascunho.temCapa;

    Widget imagemSelecionada() {
      if (arquivo != null) {
        return Image.file(
          arquivo,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        );
      }
      return Image.asset(
        asset!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: corCampoCriar,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: comErro ? Colors.redAccent : corRoxoCriar.withValues(alpha: .4),
        ),
      ),
      child: !rascunho.temCapa
          ? Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Icon(Icons.photo_camera_rounded, color: corVerdeCriar, size: 34),
            const SizedBox(height: 10),
            const Text(
              'Escolha como criar a capa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'A câmera não abre a galeria nem mostra fotos antigas do celular.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: BotaoAdicionar(
                    texto: 'Tirar foto',
                    onPressed: () => _tirarFoto(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BotaoAdicionar(
                    texto: 'Imagem pronta',
                    onPressed: () => _escolherPredefinida(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
          : ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          children: [
            imagemSelecionada(),
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: [
                  _BotaoCapa(
                    icone: Icons.photo_camera_outlined,
                    dica: 'Tirar outra foto',
                    onTap: () => _tirarFoto(context),
                  ),
                  const SizedBox(width: 8),
                  _BotaoCapa(
                    icone: Icons.collections_outlined,
                    dica: 'Usar imagem pronta',
                    onTap: () => _escolherPredefinida(context),
                  ),
                  const SizedBox(width: 8),
                  _BotaoCapa(
                    icone: Icons.delete_outline_rounded,
                    dica: 'Remover imagem',
                    onTap: rascunho.removerCapa,
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
              color: selecionado ? corVerdeCriar : corRoxoCriar.withValues(alpha: .35),
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
