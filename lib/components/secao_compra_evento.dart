import 'package:flutter/material.dart';

const List<String> _mesesExtenso = [
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro',
];

/// Ex.: 15 de Janeiro
String formatarDataExtenso(DateTime data) {
  return '${data.day} de ${_mesesExtenso[data.month - 1]}';
}

/// Ex.: 1500.5 -> R$ 1.500,50 (ou "Gratuito" se não houver preço)
String formatarPreco(double? valor) {
  if (valor == null || valor <= 0) return 'Gratuito';

  final partes = valor.toStringAsFixed(2).split('.');
  final inteiro = partes[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => '.',
  );

  return 'R\$ $inteiro,${partes[1]}';
}

/// Seção de compra do evento: preço, organizador, data/hora e ações.
/// É só visual: toda ação chega por callback, a tela decide o que fazer.
class SecaoCompraEvento extends StatelessWidget {
  final double? preco;
  final String organizador;
  final int seguidores;
  final String dataTexto;
  final String horaTexto;
  final bool favoritado;

  /// Se for null, o botão "Garantir Ingressos" aparece desativado.
  final VoidCallback? onGarantirIngressos;
  final VoidCallback onSalvar;
  final VoidCallback onAgenda;
  final VoidCallback onCompartilhar;
  final VoidCallback onReportar;
  final VoidCallback? onSeguir;

  const SecaoCompraEvento({
    super.key,
    required this.preco,
    required this.organizador,
    this.seguidores = 0,
    required this.dataTexto,
    required this.horaTexto,
    required this.favoritado,
    required this.onGarantirIngressos,
    required this.onSalvar,
    required this.onAgenda,
    required this.onCompartilhar,
    required this.onReportar,
    this.onSeguir,
  });

  static const _verde = Color(0xFF63D13E);
  static const _roxo = Color(0xFF7C2BDC);

  @override
  Widget build(BuildContext context) {
    final gratuito = preco == null || preco! <= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF140E32),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _roxo.withValues(alpha: .28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- PREÇO ---
          Text(
            gratuito ? 'INGRESSOS' : 'INGRESSOS A PARTIR DE',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formatarPreco(preco),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),

          // --- ORGANIZADOR ---
          _CardOrganizador(
            nome: organizador,
            seguidores: seguidores,
            onSeguir: onSeguir,
          ),

          const Divider(color: Colors.white12, height: 32),

          // --- DATA E HORÁRIO ---
          _RotuloValor(rotulo: 'DATA DO EVENTO', valor: dataTexto),
          const SizedBox(height: 16),
          _RotuloValor(rotulo: 'HORÁRIO DE INÍCIO', valor: horaTexto),

          const Divider(color: Colors.white12, height: 32),

          // --- BOTÕES PRINCIPAIS ---
          _BotaoParalelogramo(
            corFundo: _verde,
            corDesativado: Colors.white12,
            onTap: onGarantirIngressos,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Garantir Ingressos',
                  style: TextStyle(
                    color: onGarantirIngressos == null
                        ? Colors.white38
                        : const Color(0xFF071008),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.open_in_new_rounded,
                  size: 18,
                  color: onGarantirIngressos == null
                      ? Colors.white38
                      : const Color(0xFF071008),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _BotaoParalelogramo(
            corFundo: const Color(0xFF241A55),
            corDesativado: Colors.white12,
            onTap: onSalvar,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  favoritado
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 18,
                  color: favoritado ? _verde : Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  favoritado ? 'Evento salvo' : 'Salvar Evento',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // --- AGENDA E COMPARTILHAR ---
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onAgenda,
                  icon: const Icon(Icons.calendar_month_rounded, size: 18),
                  label: const Text('Agenda'),
                  style: _estiloOutlined(),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: onCompartilhar,
                style: _estiloOutlined().copyWith(
                  minimumSize: const WidgetStatePropertyAll(Size(52, 48)),
                  padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                ),
                child: const Icon(Icons.share_outlined, size: 18),
              ),
            ],
          ),

          const Divider(color: Colors.white12, height: 32),

          // --- REPORTAR ---
          Center(
            child: TextButton.icon(
              onPressed: onReportar,
              icon: const Icon(Icons.outlined_flag_rounded, size: 16),
              label: const Text('Reportar este evento'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white54,
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle _estiloOutlined() {
    return OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: const BorderSide(color: _roxo),
      padding: const EdgeInsets.symmetric(vertical: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _RotuloValor extends StatelessWidget {
  final String rotulo;
  final String valor;

  const _RotuloValor({required this.rotulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rotulo,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
            letterSpacing: .6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _CardOrganizador extends StatelessWidget {
  final String nome;
  final int seguidores;
  final VoidCallback? onSeguir;

  const _CardOrganizador({
    required this.nome,
    required this.seguidores,
    required this.onSeguir,
  });

  @override
  Widget build(BuildContext context) {
    final inicial = nome.trim().isEmpty ? '?' : nome.trim()[0].toUpperCase();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1442),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF7C2BDC).withValues(alpha: .25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3B1E78), Color(0xFF251660)],
              ),
            ),
            child: Text(
              inicial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ORGANIZADO POR',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                    letterSpacing: .6,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '$seguidores seguidor${seguidores == 1 ? '' : 'es'}',
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onSeguir,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF7C2BDC)),
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// Botão com as laterais inclinadas (paralelogramo), como no site.
class _BotaoParalelogramo extends StatelessWidget {
  final Color corFundo;
  final Color corDesativado;
  final VoidCallback? onTap;
  final Widget child;
  final double inclinacao;
  final double altura;

  const _BotaoParalelogramo({
    required this.corFundo,
    required this.corDesativado,
    required this.onTap,
    required this.child,
    this.inclinacao = 18,
    this.altura = 54,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _ParalelogramoClipper(inclinacao),
      child: Material(
        color: onTap == null ? corDesativado : corFundo,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: altura,
            width: double.infinity,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class _ParalelogramoClipper extends CustomClipper<Path> {
  final double inclinacao;

  const _ParalelogramoClipper(this.inclinacao);

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(inclinacao, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - inclinacao, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _ParalelogramoClipper oldClipper) {
    return oldClipper.inclinacao != inclinacao;
  }
}