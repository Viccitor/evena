import 'package:flutter/material.dart';
import 'package:evena/services/usuario_service.dart';
import 'package:evena/screens/tela_login.dart';
import 'package:evena/components/card_secao.dart';
import 'package:evena/components/perfil_favoritos.dart';
import 'package:evena/services/favoritos_service.dart';
import 'package:evena/data/eventos_data.dart';
import 'package:evena/screens/tela_detalhe_evento.dart';

class PerfilTab extends StatelessWidget {
  const PerfilTab({super.key});

  @override
  Widget build(BuildContext context) {

    return ListenableBuilder(
      listenable: UsuarioService.instance,
      builder: (context, _) {
        final usuario = UsuarioService.instance.usuario;
        final estaLogado = UsuarioService.instance.estaLogado;

        if (estaLogado) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container( //container do banner
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F165C),
                    borderRadius: BorderRadius.circular(16),

                    border: Border.all(
                      color: const Color(0xFF191628),
                      width: 1,
                    ),
                  ),

                  child: ClipRRect( //BANNER DE PERFIL
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [

                        Image.network(
                          'https://i.redd.it/fnaf-1-security-room-diorama-v0-6o8hjrmyp98c1.jpg?width=736&format=pjpg&auto=webp&s=36f683fb468601ce0d7f020f9949a3b84accabcb',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),

                        Container(
                          color: Colors.black.withValues(alpha: 0.3),
                        ),

                        Positioned(
                          top: 10,
                          right: 10,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {

                              },

                              borderRadius: BorderRadius.circular(20),

                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFF7C2BDC),
                                    width: 1,
                                  ),
                                ),

                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: Color(0xFF5CD825),
                                      size: 14,
                                    ),

                                    SizedBox(width: 4),
                                    Text(
                                      'Alterar banner',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Container( //container da foto de perfil
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2F165C),
                                    borderRadius: BorderRadius.circular(100),

                                    border: Border.all(
                                      color: const Color(0xFF5CD825),
                                      width: 1,
                                    ),
                                  ),

                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Stack(
                                      children: [

                                        Image.network(
                                          'https://cdn.britannica.com/52/243652-050-FEE0A5E4/Actor-Adam-Sandler-2019.jpg',
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),

                                  ),
                                ),

                                SizedBox(height: 10),

                                Text(
                                  'Victor',

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(
                                  usuario?.nome != null ? '@${usuario!.nome}' : 'Algo deu errado',

                                  style: const TextStyle(
                                    color: Colors.purple,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ],
                            ),

                          ),
                        ),

                      ],
                    ),
                  ),

                ),

                SizedBox(height: 20),

                // --- AQUI ENTRA A SEÇÃO DE EVENTOS FAVORITADOS DINÂMICA ---
                AnimatedBuilder(
                  animation: FavoritosService.instance,
                  builder: (context, _) {
                    final favoritos = FavoritosService.instance;
                    final listaFavoritos = eventos
                        .where((e) => favoritos.contem(e.id))
                        .toList();

                    return CardSecao(
                      titulo: 'Eventos favoritados',
                      icone: Icons.favorite,
                      conteudo: listaFavoritos.isEmpty
                          ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Nenhum evento favoritado ainda.',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      )
                          : SizedBox(
                        height: 180,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: listaFavoritos.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final eventoItem = listaFavoritos[index];
                            return PerfilFavoritos(
                              evento: eventoItem,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TelaDetalheEvento(evento: eventoItem),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),

              ],
            ),
          );

        } else {

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TelaLogin()),
                      );
                    },

                  ),

                ],
              ),
            ),
          );
        }

      },
    );
  }
}