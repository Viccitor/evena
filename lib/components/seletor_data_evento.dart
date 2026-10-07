import 'package:evena/components/secao_compra_evento.dart';
import 'package:evena/models/evento.dart';
import 'package:flutter/material.dart';

/// Aba de datas do evento (igual à do site): uma linha por data, com o
/// quadradinho "SÁB 07" e o horário. A data escolhida fica em destaque.
class SeletorDataEvento extends StatelessWidget {
  final List<DataEvento> datas;
  final int selecionada;
  final ValueChanged<int> onSelecionar;

  const SeletorDataEvento({
    super.key,
    required this.datas,
    required this.selecionada,
    required this.onSelecionar,
  });

  static const _lavanda = Color(0xFFC9C2EA);
  static const _roxoEscuro = Color(0xFF2D1B69);
  static const _verde = Color(0xFF63D13E);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_month_rounded,
                color: Color(0xFF9A77D5), size: 20),
            const SizedBox(width: 8),
            const Text(
              'Datas do evento',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${datas.length} datas',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < datas.length; i++) ...[
          _LinhaData(
            data: datas[i],
            ativa: i == selecionada,
            onTap: () => onSelecionar(i),
          ),
          if (i != datas.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _LinhaData extends StatelessWidget {
  final DataEvento data;
  final bool ativa;
  final VoidCallback onTap;

  const _LinhaData({
    required this.data,
    required this.ativa,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final corTexto = ativa ? SeletorDataEvento._roxoEscuro : Colors.white;
    final corSecundaria = ativa ? const Color(0xFF4A3B8C) : Colors.white60;

    return Material(
      color: ativa ? SeletorDataEvento._lavanda : const Color(0xFF140E32),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ativa
                  ? SeletorDataEvento._verde
                  : const Color(0xFF7C2BDC).withValues(alpha: .28),
              width: ativa ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: SeletorDataEvento._roxoEscuro,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.diaSemanaAbrev,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      data.dia,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data.diaSemanaExtenso}, ${formatarDataExtenso(data.inicio)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: corTexto,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.intervaloHora,
                      style: TextStyle(color: corSecundaria, fontSize: 13),
                    ),
                  ],
                ),
              ),
              if (ativa)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.check_circle_rounded,
                      color: SeletorDataEvento._roxoEscuro),
                ),
            ],
          ),
        ),
      ),
    );
  }
}