import 'package:evena/components/criar_evento/campos_criar_evento.dart';
import 'package:evena/models/rascunho_evento.dart';
import 'package:flutter/material.dart';

class PassoDataLocal extends StatelessWidget {
  final RascunhoEvento rascunho;

  const PassoDataLocal({super.key, required this.rascunho});

  static const Map<String, String> _descricaoFormato = {
    'Presencial': 'O evento acontecerá em um local físico.',
    'Online': 'O evento acontecerá pela internet.',
    'Híbrido': 'O evento acontecerá presencialmente e online.',
  };

  DateTime get _hoje {
    final agora = DateTime.now();
    return DateTime(agora.year, agora.month, agora.day);
  }

  Future<void> _escolherData(BuildContext context, DataRascunho item) async {
    final primeiro = _hoje;
    final atual = item.data;
    final inicial = (atual != null && !atual.isBefore(primeiro))
        ? atual
        : primeiro;

    final escolhida = await showDatePicker(
      context: context,
      initialDate: inicial,
      firstDate: primeiro,
      lastDate: DateTime(primeiro.year + 5, 12, 31),
      helpText: 'Data do evento',
      cancelText: 'Cancelar',
      confirmText: 'OK',
    );

    if (escolhida == null) return;

    item.data = DateTime(escolhida.year, escolhida.month, escolhida.day);
    rascunho.atualizar();
  }

  Future<TimeOfDay?> _escolherHora(
      BuildContext context,
      TimeOfDay? atual,
      String titulo,
      ) {
    return showTimePicker(
      context: context,
      initialTime: atual ?? const TimeOfDay(hour: 20, minute: 0),
      helpText: titulo,
      cancelText: 'Cancelar',
      confirmText: 'OK',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
  }

  Future<void> _escolherInicio(BuildContext context, DataRascunho item) async {
    final hora = await _escolherHora(context, item.inicio, 'Horário de início');
    if (hora == null) return;

    item.inicio = hora;
    rascunho.atualizar();
  }

  Future<void> _escolherFim(BuildContext context, DataRascunho item) async {
    final hora = await _escolherHora(
      context,
      item.fim ?? item.inicio,
      'Horário de término',
    );
    if (hora == null) return;

    item.fim = hora;
    rascunho.atualizar();
  }

  Future<void> _adicionarConsecutivas(BuildContext context) async {
    final primeiro = _hoje;

    final intervalo = await showDateRangePicker(
      context: context,
      firstDate: primeiro,
      lastDate: DateTime(primeiro.year + 5, 12, 31),
      helpText: 'Período do evento',
      cancelText: 'Cancelar',
      confirmText: 'OK',
      saveText: 'OK',
    );

    if (intervalo == null) return;

    final inicio = intervalo.start;
    final fim = intervalo.end;

    final totalDias = DateTime.utc(fim.year, fim.month, fim.day)
        .difference(DateTime.utc(inicio.year, inicio.month, inicio.day))
        .inDays;

    if (totalDias > 30) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Escolha no máximo 31 dias seguidos.')),
        );
      }
      return;
    }

    // Reaproveita os horários da primeira data que já tiver horário.
    final modelo = rascunho.datas.firstWhere(
          (d) => d.inicio != null,
      orElse: () => DataRascunho(),
    );

    // Descarta linhas totalmente vazias antes de adicionar o período.
    rascunho.datas.removeWhere(
          (d) => d.data == null && d.inicio == null && d.fim == null,
    );

    for (var i = 0; i <= totalDias; i++) {
      rascunho.datas.add(
        DataRascunho(
          data: DateTime(inicio.year, inicio.month, inicio.day + i),
          inicio: modelo.inicio,
          fim: modelo.fim,
        ),
      );
    }

    rascunho.atualizar();
  }

  @override
  Widget build(BuildContext context) {
    final erroFormato = rascunho.mostrarErros && rascunho.formato == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- DATAS ---
        const RotuloCampo(texto: 'Datas do evento', obrigatorio: true),
        const SizedBox(height: 4),
        const Text(
          'Adicione uma ou mais datas para o seu evento.',
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < rascunho.datas.length; i++) ...[
          _buildData(context, i),
          const SizedBox(height: 12),
        ],
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            BotaoAdicionar(
              texto: '+ Adicionar data',
              onPressed: () {
                rascunho.datas.add(DataRascunho());
                rascunho.atualizar();
              },
            ),
            BotaoAdicionar(
              texto: '+ Adicionar datas consecutivas',
              onPressed: () => _adicionarConsecutivas(context),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // --- FORMATO ---
        const RotuloCampo(texto: 'Como será o evento?', obrigatorio: true),
        const SizedBox(height: 4),
        const Text(
          'Escolha o formato do evento.',
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 12),
        for (final formato in formatosEvento) ...[
          OpcaoSelecionavel(
            titulo: formato,
            subtitulo: _descricaoFormato[formato],
            selecionado: rascunho.formato == formato,
            onTap: () {
              rascunho.formato = formato;
              rascunho.atualizar();
            },
          ),
          const SizedBox(height: 10),
        ],
        TextoErroCampo(erroFormato ? 'Escolha o formato do evento' : null),

        // --- LOCAL (presencial / híbrido) ---
        if (rascunho.presencial) ...[
          const SizedBox(height: 18),
          SecaoCriarEvento(
            titulo: 'Local do evento',
            subtitulo: 'Onde as pessoas devem ir.',
            child: Column(
              children: [
                CampoCriarEvento(
                  rotulo: 'Nome do local',
                  obrigatorio: true,
                  hint: 'Ex: Allianz Parque',
                  controller: rascunho.local,
                  errorText: _obrigatorio(rascunho.local.text),
                  aoDigitar: rascunho.aoDigitar,
                ),
                const SizedBox(height: 16),
                CampoCriarEvento(
                  rotulo: 'Endereço',
                  obrigatorio: true,
                  hint: 'Ex: Rua Palestra Itália, 200 - Água Branco, São Paulo',
                  controller: rascunho.endereco,
                  maxLines: 2,
                  errorText: _obrigatorio(rascunho.endereco.text),
                  aoDigitar: rascunho.aoDigitar,
                ),
              ],
            ),
          ),
        ],

        // --- LINK (online / híbrido) ---
        if (rascunho.online) ...[
          const SizedBox(height: 18),
          SecaoCriarEvento(
            titulo: 'Acesso online',
            subtitulo: 'Link para quem vai participar pela internet.',
            child: CampoCriarEvento(
              rotulo: 'Link do evento',
              obrigatorio: true,
              hint: 'https://...',
              controller: rascunho.linkOnline,
              keyboardType: TextInputType.url,
              errorText: _obrigatorio(rascunho.linkOnline.text),
              aoDigitar: rascunho.aoDigitar,
            ),
          ),
        ],
      ],
    );
  }

  String? _obrigatorio(String texto) {
    return rascunho.mostrarErros && texto.trim().isEmpty
        ? 'Campo obrigatório'
        : null;
  }

  Widget _buildData(BuildContext context, int indice) {
    final item = rascunho.datas[indice];
    final erros = rascunho.mostrarErros;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: corCardCriar,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: corRoxoCriar.withValues(alpha: .28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Data ${indice + 1}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (rascunho.datas.length > 1)
                InkWell(
                  onTap: () {
                    rascunho.datas.removeAt(indice);
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
          CampoSelecao(
            rotulo: 'Data',
            placeholder: 'dd/mm/aaaa',
            icone: Icons.calendar_today_outlined,
            valor: item.data == null ? null : formatarDataCurta(item.data!),
            errorText: erros && item.data == null ? 'Informe a data' : null,
            onTap: () => _escolherData(context, item),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CampoSelecao(
                  rotulo: 'Início',
                  placeholder: '--:--',
                  icone: Icons.access_time_rounded,
                  valor: item.inicio == null
                      ? null
                      : formatarHora(item.inicio!),
                  errorText:
                  erros && item.inicio == null ? 'Informe o início' : null,
                  onTap: () => _escolherInicio(context, item),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CampoSelecao(
                  rotulo: 'Término (opcional)',
                  placeholder: '--:--',
                  icone: Icons.access_time_rounded,
                  valor: item.fim == null ? null : formatarHora(item.fim!),
                  onTap: () => _escolherFim(context, item),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}