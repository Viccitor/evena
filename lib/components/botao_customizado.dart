import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final bool temSeta;
  final bool isSecundario; // Para o botão roxo com borda

  const BotaoCustomizado({
    super.key,
    required this.texto,
    required this.onPressed,
    this.temSeta = true,       // Por padrão vem com a seta
    this.isSecundario = false, // Por padrão é o botão verde principal
  });

  @override
  Widget build(BuildContext context) {
    // 🎨 Cores para o estilo Principal (Verde) vs Secundário (Roxo com Borda)
    final Color corFundo = isSecundario ? const Color(0xFF000010) : const Color(0xFF5CD825);
    final Color corTexto = isSecundario ? const Color(0XFFA62CFB) : Colors.black;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: corFundo,
          foregroundColor: corTexto,
          disabledBackgroundColor: const Color(0xFF1E1E2C),
          disabledForegroundColor: Colors.white30,
          elevation: 0,
          side: isSecundario
              ? const BorderSide(color: Color(0XFFA62CFB), width: 0.5)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: temSeta
            ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 20), // Para empurrar o texto para o centro
            Text(
              texto,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
            ),
          ],
        )
            : Text(
          texto,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}