import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color corVerdeCriar = Color(0xFF63D13E);
const Color corRoxoCriar = Color(0xFF7C2BDC);
const Color corCardCriar = Color(0xFF140E32);
const Color corCampoCriar = Color(0xFF0E0A26);
const Color corTextoEscuroCriar = Color(0xFF071008);

/// Visual padrão dos campos do assistente (igual ao resto do app).
InputDecoration decoracaoCampo({
  String? hint,
  String? errorText,
  String? prefixText,
  Widget? suffixIcon,
}) {
  OutlineInputBorder borda(Color cor, [double largura = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: cor, width: largura),
    );
  }

  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
    errorText: errorText,
    errorMaxLines: 2,
    prefixText: prefixText,
    prefixStyle: const TextStyle(color: Colors.white70, fontSize: 14),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: corCampoCriar,
    counterStyle: const TextStyle(color: Colors.white38),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: borda(const Color(0xFF3B1E78)),
    border: borda(const Color(0xFF3B1E78)),
    focusedBorder: borda(corVerdeCriar, 1.5),
    errorBorder: borda(Colors.redAccent),
    focusedErrorBorder: borda(Colors.redAccent, 1.5),
  );
}

/// Título de um campo, com asterisco vermelho se for obrigatório.
class RotuloCampo extends StatelessWidget {
  final String texto;
  final bool obrigatorio;

  const RotuloCampo({super.key, required this.texto, this.obrigatorio = false});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: texto,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        children: [
          if (obrigatorio)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.redAccent),
            ),
        ],
      ),
    );
  }
}

/// Campo de texto com rótulo em cima.
class CampoCriarEvento extends StatelessWidget {
  final String rotulo;
  final bool obrigatorio;
  final String? hint;
  final TextEditingController controller;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String? errorText;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? aoDigitar;

  const CampoCriarEvento({
    super.key,
    required this.rotulo,
    required this.controller,
    this.obrigatorio = false,
    this.hint,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.errorText,
    this.prefixText,
    this.inputFormatters,
    this.aoDigitar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RotuloCampo(texto: rotulo, obrigatorio: obrigatorio),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: (_) => aoDigitar?.call(),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: decoracaoCampo(
            hint: hint,
            errorText: errorText,
            prefixText: prefixText,
          ),
        ),
      ],
    );
  }
}

/// Campo que não digita: mostra um valor e abre um seletor ao tocar
/// (data, horário...).
class CampoSelecao extends StatelessWidget {
  final String rotulo;
  final bool obrigatorio;
  final String placeholder;
  final String? valor;
  final IconData icone;
  final String? errorText;
  final VoidCallback onTap;

  const CampoSelecao({
    super.key,
    required this.rotulo,
    required this.placeholder,
    required this.icone,
    required this.onTap,
    this.valor,
    this.obrigatorio = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RotuloCampo(texto: rotulo, obrigatorio: obrigatorio),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: InputDecorator(
            decoration: decoracaoCampo(
              errorText: errorText,
              suffixIcon: Icon(icone, color: Colors.white54, size: 18),
            ),
            child: Text(
              valor ?? placeholder,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: valor == null ? Colors.white38 : Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Bloco com título e subtítulo para agrupar campos (Ingressos, Atrações...).
class SecaoCriarEvento extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final Widget child;

  const SecaoCriarEvento({
    super.key,
    required this.titulo,
    required this.child,
    this.subtitulo,
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
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (subtitulo != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitulo!,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

/// Opção de escolha única em formato de cartão (formato do evento, ingresso).
class OpcaoSelecionavel extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final bool selecionado;
  final VoidCallback onTap;

  const OpcaoSelecionavel({
    super.key,
    required this.titulo,
    required this.selecionado,
    required this.onTap,
    this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selecionado
          ? corVerdeCriar.withValues(alpha: .10)
          : corCampoCriar,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selecionado
                  ? corVerdeCriar
                  : corRoxoCriar.withValues(alpha: .35),
              width: selecionado ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selecionado ? corVerdeCriar : Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (subtitulo != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitulo!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Mensagem de erro vermelha para campos que não são TextField.
class TextoErroCampo extends StatelessWidget {
  final String? texto;

  const TextoErroCampo(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    if (texto == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        texto!,
        style: const TextStyle(color: Colors.redAccent, fontSize: 12),
      ),
    );
  }
}

/// Botão contornado de verde, como "+ Adicionar data".
class BotaoAdicionar extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;

  const BotaoAdicionar({
    super.key,
    required this.texto,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: corVerdeCriar),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(texto),
    );
  }
}

/// Bolinhas 1-2-3-4 ligadas por linhas, com o nome do passo atual embaixo.
class IndicadorPassos extends StatelessWidget {
  final int passoAtual;
  final List<String> titulos;

  const IndicadorPassos({
    super.key,
    required this.passoAtual,
    required this.titulos,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < titulos.length; i++) ...[
              _Bolinha(
                numero: i + 1,
                concluido: i < passoAtual,
                atual: i == passoAtual,
              ),
              if (i < titulos.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    color: i < passoAtual ? corVerdeCriar : Colors.white12,
                  ),
                ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Passo ${passoAtual + 1} de ${titulos.length} · ${titulos[passoAtual]}',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _Bolinha extends StatelessWidget {
  final int numero;
  final bool concluido;
  final bool atual;

  const _Bolinha({
    required this.numero,
    required this.concluido,
    required this.atual,
  });

  @override
  Widget build(BuildContext context) {
    final ativa = concluido || atual;

    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ativa ? corVerdeCriar : Colors.transparent,
        border: Border.all(color: ativa ? corVerdeCriar : Colors.white24),
      ),
      child: concluido
          ? const Icon(Icons.check_rounded, size: 16, color: corTextoEscuroCriar)
          : Text(
        '$numero',
        style: TextStyle(
          color: atual ? corTextoEscuroCriar : Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}