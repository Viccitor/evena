import 'package:flutter/material.dart';

class BotaoVerMais extends StatelessWidget { //classe do botão ver Mais
  final VoidCallback aoClicar;
  final String texto;

  const BotaoVerMais({
    super.key,
    required this.aoClicar,
    this.texto = 'Ver mais >',
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: aoClicar,
      child: Text(
        texto,
        style: const TextStyle(
          color: Color(0xFF63D13E),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
