import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evena/models/evento.dart';
import 'package:evena/data/eventos_data.dart';
import 'package:evena/components/card_evento.dart';
import 'package:evena/components/cards_categoria.dart';
import 'package:evena/screens/tela_detalhe_evento.dart';
import 'package:evena/screens/tela_inicio.dart';
import 'package:evena/screens/tela_pesquisa.dart';
import 'package:evena/screens/tela_favoritos.dart';
import 'package:evena/screens/tela_perfil.dart';

class TelaHome extends StatefulWidget {
  const TelaHome({super.key});

  @override
  State<TelaHome> createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  int _indiceAtual = 0;

  void _abrirEvento(Evento evento) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TelaDetalheEvento(evento: evento)),
    );
  }

  void _abrirPesquisa() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaPesquisa()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usando as telas importadas diretamente na lista
    final paginas = [
      _InicioTab(onAbrirEvento: _abrirEvento, onPesquisar: _abrirPesquisa),
      FavoritosTab(onAbrirEvento: _abrirEvento),
      const PerfilTab(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF080427),
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF01011D),
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: -16,
        title: Image.asset('assets/images/logo_evena_s_fundo.png', height: 120),
        actions: [
          if (_indiceAtual != 2)
            IconButton(
              tooltip: 'Pesquisar',
              onPressed: _abrirPesquisa,
              icon: const Icon(Icons.search_rounded, color: Colors.white),
            ),
          const SizedBox(width: 6),
        ],
      ),
      body: IndexedStack(index: _indiceAtual, children: paginas),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.poppins(
                color: const Color(0xFF63D13E),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              );
            }
            return GoogleFonts.poppins(
              color: Colors.white54,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: _indiceAtual,
          height: 68,
          backgroundColor: const Color(0xFF181236),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) =>
              setState(() => _indiceAtual = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white54),
              selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF63D13E)),
              label: 'Início',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border_rounded, color: Colors.white54),
              selectedIcon: Icon(
                Icons.favorite_rounded,
                color: Color(0xFF63D13E),
              ),
              label: 'Favoritos',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded, color: Colors.white54),
              selectedIcon: Icon(
                Icons.person_rounded,
                color: Color(0xFF63D13E),
              ),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF100B2A),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: ClipRect(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/logo_evena_s_fundo.png',
                    ),
                  ),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(
                Icons.home_outlined,
                color: Color(0xFF63D13E),
              ),
              title: const Text(
                'Início',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() => _indiceAtual = 0);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.favorite_border_rounded,
                color: Color(0xFF9A77D5),
              ),
              title: const Text(
                'Favoritos',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() => _indiceAtual = 1);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.person_add_alt_1_rounded,
                color: Color(0xFF9A77D5),
              ),
              title: const Text(
                'Cadastro / Login',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TelaInicio()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InicioTab extends StatelessWidget {
  final ValueChanged<Evento> onAbrirEvento;
  final VoidCallback onPesquisar;

  const _InicioTab({required this.onAbrirEvento, required this.onPesquisar});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 6),

          _TituloSecao(
            titulo: 'Destaques para você',
            quantidade: eventos.length,
          ),
          const SizedBox(height: 12),
          CardEvento(
            evento: eventos.first,
            onTap: () => onAbrirEvento(eventos.first),
          ),
          const SizedBox(height: 26),
          const Text(
            'Categorias',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CardCategoria(
                  caminhoImagem: 'assets/images/negocios.png',
                  texto: 'Networking',
                ),
                SizedBox(width: 10),
                CardCategoria(
                  caminhoImagem: 'assets/images/shows.png',
                  texto: 'Música',
                ),
                SizedBox(width: 10),
                CardCategoria(
                  caminhoImagem: 'assets/images/teatro.png',
                  texto: 'Teatro',
                ),
                SizedBox(width: 10),
                CardCategoria(
                  caminhoImagem: 'assets/images/viagem.png',
                  texto: 'Festival',
                ),
                SizedBox(width: 10),
                CardCategoria(
                  caminhoImagem: 'assets/images/tech.png',
                  texto: 'Tecnologia',
                ),
                SizedBox(width: 10),
                CardCategoria(
                  caminhoImagem: 'assets/images/gastronomia.png',
                  texto: 'Gastronomia',
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Próximos eventos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...eventos
              .skip(1)
              .map(
                (evento) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CardEvento(
                evento: evento,
                compacto: true,
                onTap: () => onAbrirEvento(evento),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TituloSecao extends StatelessWidget {
  final String titulo;
  final int quantidade;
  const _TituloSecao({required this.titulo, required this.quantidade});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF63D13E).withValues(alpha: .12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$quantidade eventos',
            style: const TextStyle(
              color: Color(0xFF63D13E),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}