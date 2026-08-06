import 'package:flutter/material.dart';
import 'package:evena/models/evento.dart';
import 'package:evena/components/botao_ver_mais.dart';
import 'package:evena/components/card_secao.dart';

class TelaDetalheEvento extends StatefulWidget {
  final Evento evento;

  const TelaDetalheEvento({super.key, required this.evento});

  @override
  State<TelaDetalheEvento> createState() => _TelaDetalheEventoState();
}

class _TelaDetalheEventoState extends State<TelaDetalheEvento> {
  bool _estaExpandido = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02010F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF01011D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: Row(
          children: [
            Transform.translate(
              offset: const Offset(-15, 5),
              child: Image.asset(
                'assets/images/logo_evena_s_fundo.png',
                height: 130,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // IMAGEM COM A BORDA E O TEXTO POR CIMA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: const Color(0xFF7C2BDC),
                    width: 1.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: Stack(
                    children: [
                      // 1. Imagem do evento no fundo
                      Image.asset(
                        widget.evento.imagemUrl,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),

                      // 2. Gradiente escuro na parte inferior
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.5),
                                Colors.black.withValues(alpha: 0.85),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Positioned como FILHO DIRETO do Stack
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título do evento
                            Text(
                              widget.evento.titulo,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 6),

                            // Ícone e Localização
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Color(0xFF8E68CD),
                                  size: 19,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.evento.local,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // CONTEÚDO E DETALHES DO EVENTO
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Data do Evento
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Color(0xFF63D13E),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Data: ${widget.evento.dia} de ${widget.evento.mes} às ${widget.evento.hora}',
                        style: const TextStyle(
                          color: Color(0xFF63D13E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // CARD: SOBRE O EVENTO
                  CardSecao(
                    titulo: 'Sobre o evento',
                    icone: Icons.info_outline,
                    conteudo: LayoutBuilder(
                      builder: (context, constraints) {
                        final estiloTexto = const TextStyle(
                          color: Colors.white70,
                          height: 1.4,
                          fontSize: 13,
                        );

                        final textPainter = TextPainter(
                          text: TextSpan(
                              text: widget.evento.descricao,
                              style: estiloTexto),
                          maxLines: 3,
                          textDirection: TextDirection.ltr,
                        )..layout(maxWidth: constraints.maxWidth);

                        final ultrapassouLimite =
                            textPainter.didExceedMaxLines;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.evento.descricao,
                              maxLines: _estaExpandido ? null : 3,
                              overflow: _estaExpandido
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                              style: estiloTexto,
                            ),
                            if (ultrapassouLimite) ...[
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: BotaoVerMais(
                                  texto: _estaExpandido
                                      ? 'Ver menos <'
                                      : 'Ver mais >',
                                  aoClicar: () {
                                    setState(() {
                                      _estaExpandido = !_estaExpandido;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),


                  CardSecao(
                    titulo: 'Informações Gerais',
                    icone: Icons.star_outline_outlined,
                    conteudo: Row(
                      children: [
                        //  Card Formato
                        _buildItemInfo(
                          icone: Icons.devices_outlined,
                          titulo: 'FORMATO',
                          dado: widget.evento.formato,
                        ),
                        const SizedBox(width: 8),

                        // Card Faixa Etária
                        _buildItemInfo(
                          icone: Icons.people_outline,
                          titulo: 'FAIXA ETÁRIA',
                          dado: 'Livre',
                        ),
                        const SizedBox(width: 8),

                        // Card Tipo
                        _buildItemInfo(
                          icone: Icons.confirmation_number_outlined,
                          titulo: 'TIPO',
                          dado: 'Ingresso',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildItemInfo({
    required IconData icone,
    required String titulo,
    required String? dado,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFF140E32),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: const Color(0xFF7C2BDC).withValues(alpha: 0.2),
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icone,
              color: const Color(0xFF8E68CD),
              size: 20,
            ),
            const SizedBox(height: 6),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Colors.white54,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              dado ?? '-',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}