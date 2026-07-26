import 'package:flutter/material.dart';



class CampoTextoCustomizado extends StatefulWidget {
  final String titulo;
  final String labelText;
  final IconData prefixIcon;
  final bool isSenha;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const CampoTextoCustomizado({
    super.key,
    required this.titulo,
    required this.labelText,
    required this.prefixIcon,
    this.isSenha = false,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  State<CampoTextoCustomizado> createState() => _CampoTextoCustomizadoState();
}

class _CampoTextoCustomizadoState extends State<CampoTextoCustomizado> {
  late bool _esconderTexto;

  @override
  void initState() {
    super.initState();
    _esconderTexto = widget.isSenha;

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          widget.titulo,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        // Campo de Texto
        TextField(
          controller: widget.controller,
          obscureText: _esconderTexto,
          keyboardType: widget.keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: const TextStyle(color: Colors.white38),
            prefixIcon: Icon(widget.prefixIcon),

            // Cor dinâmica do ícone da esquerda
            prefixIconColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.focused)) {
                return const Color(0xFF63D13E);
              }
              return const Color(0XFFA62CFB);
            }),





            suffixIcon: widget.isSenha
                ? IconButton(
              icon: Icon(
                _esconderTexto
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.white70,
              ),
              onPressed: () {
                // Inverte a visibilidade ao clicar no olho
                setState(() {
                  _esconderTexto = !_esconderTexto;
                });
              },
            )
                : null,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF3B1E78)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF63D13E), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}