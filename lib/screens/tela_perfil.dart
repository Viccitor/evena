import 'package:flutter/material.dart';

class PerfilTab extends StatelessWidget {
  const PerfilTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: Color(0xFF1D1544),
            child: Icon(
              Icons.person_rounded,
              color: Color(0xFF63D13E),
              size: 46,
            ),
          ),
          SizedBox(height: 14),
          Text(
            'Seu perfil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Área pronta para evoluir depois.',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}