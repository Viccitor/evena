import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:evena/services/auth_service.dart';
import 'package:evena/screens/tela_login.dart';
import 'package:evena/components/card_secao.dart';
import 'package:evena/components/perfil_favoritos.dart';
import 'package:evena/services/favoritos_service.dart';
import 'package:evena/data/eventos_data.dart';
import 'package:evena/screens/tela_detalhe_evento.dart';
import 'package:evena/components/perfil_conquistas.dart';
import 'package:evena/components/card_historico_evento.dart';

class PerfilTab extends StatefulWidget {
  const PerfilTab({super.key});

  @override
  State<PerfilTab> createState() => _PerfilTabState();
}

class _PerfilTabState extends State<PerfilTab> {
  bool _historicoExpandido = false;

  // Imagens locais selecionadas do dispositivo
  File? _bannerFile;
  File? _perfilFile; // <--- Arquivo para a foto de perfil

  // URLs padrão de fallback
  final String _bannerUrlPadrao =
      'https://i.redd.it/fnaf-1-security-room-diorama-v0-6o8hjrmyp98c1.jpg?width=736&format=pjpg&auto=webp&s=36f683fb468601ce0d7f020f9949a3b84accabcb';

  final String _perfilUrlPadrao =
      'https://cdn.britannica.com/52/243652-050-FEE0A5E4/Actor-Adam-Sandler-2019.jpg';

  // Função para alterar o banner
  Future<void> _alterarBanner() async {
    final picker = ImagePicker();
    final XFile? imagemSelecionada = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (imagemSelecionada != null) {
      setState(() {
        _bannerFile = File(imagemSelecionada.path);
      });
    }
  }

  // Função para alterar a foto de perfil
  Future<void> _alterarFotoPerfil() async {
    final picker = ImagePicker();
    final XFile? imagemSelecionada = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (imagemSelecionada != null) {
      setState(() {
        _perfilFile = File(imagemSelecionada.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.perfilListenable,
      builder: (context, _) {
        final perfil = AuthService.perfilAtual;

        if (perfil != null) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- BANNER DE PERFIL ---
                Container(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        _bannerFile != null
                            ? Image.file(
                          _bannerFile!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        )
                            : Image.network(
                          _bannerUrlPadrao,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: Colors.black.withValues(alpha: 0.3),
                        ),
                        // Botão de alterar Banner
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _alterarBanner,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
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
                        // Bloco da Foto de Perfil + Nome
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // --- FOTO DE PERFIL CLICÁVEL ---
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: _alterarFotoPerfil,
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2F165C),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFF5CD825),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: _perfilFile != null
                                              ? Image.file(
                                            _perfilFile!,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                              : Image.network(
                                            _perfilUrlPadrao,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Ícone de câmera no canto da foto
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: _alterarFotoPerfil,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(alpha: 0.8),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color(0xFF5CD825),
                                              width: 1,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt,
                                            color: Color(0xFF5CD825),
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                Text(
                                  perfil.nome,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  perfil.email,
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

                const SizedBox(height: 20),

                // --- SEÇÃO DE EVENTOS FAVORITADOS DINÂMICA ---
                AnimatedBuilder(
                  animation: FavoritosService.instance,
                  builder: (context, _) {
                    final favoritos = FavoritosService.instance;
                    final listaFavoritos = eventos
                        .where((e) => favoritos.contem(e.id))
                        .toList();

                    return CardSecao(
                      titulo: 'Eventos favoritados',
                      icone: Icons.favorite_outline,
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
                          separatorBuilder: (_, _) =>
                          const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            final eventoItem = listaFavoritos[index];
                            return PerfilFavoritos(
                              evento: eventoItem,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TelaDetalheEvento(
                                        evento: eventoItem),
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

                const SizedBox(height: 20),

                // --- SEÇÃO DE SUAS CONQUISTAS ---
                CardSecao(
                  titulo: 'Suas conquistas',
                  icone: Icons.emoji_events_outlined,
                  conteudo: SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final conquistas = [
                          {
                            'titulo': 'Pioneiro',
                            'descricao': '1º evento garantido',
                            'icone': Icons.emoji_events,
                            'cor': const Color(0xFF63D13E),
                          },
                          {
                            'titulo': 'Festeiro',
                            'descricao': 'Presença em 5 eventos',
                            'icone': Icons.local_fire_department,
                            'cor': const Color(0xFFFF9800),
                          },
                          {
                            'titulo': 'Explorador',
                            'descricao': 'Salvou 10 eventos',
                            'icone': Icons.explore,
                            'cor': const Color(0xFF2196F3),
                          },
                        ];

                        final item = conquistas[index];

                        return PerfilConquistas(
                          titulo: item['titulo'] as String,
                          descricao: item['descricao'] as String,
                          icone: item['icone'] as IconData,
                          corIcone: item['cor'] as Color,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- HISTÓRICO DE EVENTOS ---
                CardSecao(
                  titulo: 'Histórico de eventos',
                  icone: Icons.history_rounded,
                  expansivel: eventos.length > 1,
                  expandido: _historicoExpandido,
                  onToggle: () {
                    setState(() {
                      _historicoExpandido = !_historicoExpandido;
                    });
                  },
                  conteudo: Column(
                    children: (_historicoExpandido
                        ? eventos
                        : eventos.take(1).toList())
                        .map((eventoItem) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: CardHistoricoEvento(
                          evento: eventoItem,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TelaDetalheEvento(evento: eventoItem),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
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