import 'package:flutter/material.dart';
import 'package:evena/services/usuario_service.dart';
import 'package:evena/screens/tela_login.dart';

class PerfilTab extends StatelessWidget {
  const PerfilTab({super.key});

  @override
  Widget build(BuildContext context) {

    return Center(
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
        
        ListenableBuilder(
          listenable: UsuarioService.instance,
          builder: (context, _) {
            final usuario = UsuarioService.instance.usuario;
            final estaLogado = UsuarioService.instance.estaLogado;

            if(estaLogado){

              return Text(
                usuario?.nome ?? 'Algo deu errado',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              );

            }else{

              return Column(
                children: [

                  const Text(
                    'Parece que você ainda não está logado',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                  ),
                ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF63D13E),
                      foregroundColor: Colors.black,
                    ),

                    child: const Text('Fazer Login'),

                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TelaLogin()),
                      );
                    },

                  ),

                  ],
                );
            }

          },
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