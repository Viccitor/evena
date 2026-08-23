import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
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
  late final PageController _pageController;

  // Estado da lista de eventos e localização
  List<Evento> _listaEventos = List.from(eventos);
  bool _carregandoLocalizacao = false;
  Position? _posicaoAtual;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _indiceAtual);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Método responsável por pedir permissão e obter a localização do usuário
  Future<void> _ativarLocalizacao() async {
    setState(() => _carregandoLocalizacao = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _mostrarSnackBar('Por favor, ative o GPS do seu celular.');
        setState(() => _carregandoLocalizacao = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _mostrarSnackBar('Permissão de localização negada.');
          setState(() => _carregandoLocalizacao = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _mostrarSnackBar(
          'Permissões negadas permanentemente. Ative nas configurações do aparelho.',
        );
        setState(() => _carregandoLocalizacao = false);
        return;
      }

      // Obtém a posição atual do aparelho
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // Reordena os eventos com base na distância
      List<Evento> eventosOrdenados = List.from(_listaEventos);
      eventosOrdenados.sort((a, b) {
        double distA = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          a.latitude,
          a.longitude,
        );
        double distB = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          b.latitude,
          b.longitude,
        );
        return distA.compareTo(distB);
      });

      setState(() {
        _posicaoAtual = position;
        _listaEventos = eventosOrdenados;
        _carregandoLocalizacao = false;
      });

      _mostrarSnackBar('Eventos reordenados pela sua localização!');
    } catch (e) {
      _mostrarSnackBar('Erro ao obter localização: $e');
      setState(() => _carregandoLocalizacao = false);
    }
  }

  void _mostrarSnackBar(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: const Color(0xFF181236),
      ),
    );
  }

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

  void _mudarAba(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final paginas = [
      _InicioTab(
        onAbrirEvento: _abrirEvento,
        onPesquisar: _abrirPesquisa,
        onAtivarLocalizacao: _ativarLocalizacao,
        carregandoLocalizacao: _carregandoLocalizacao,
        posicaoAtiva: _posicaoAtual != null,
        eventos: _listaEventos,
      ),
      FavoritosTab(onAbrirEvento: _abrirEvento),
      const PerfilTab(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF080427),
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF01011D),
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: -12,
        title: Image.asset(
          'assets/images/logo_evena_s_fundo.png',
          height: 120,
          fit: BoxFit.contain,
        ),
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
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _indiceAtual = index);
        },
        children: paginas,
      ),
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
          onDestinationSelected: _mudarAba,
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
              selected: _indiceAtual == 0,
              selectedTileColor: const Color(0xFF1F1843),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: Icon(
                _indiceAtual == 0 ? Icons.home_rounded : Icons.home_outlined,
                color: _indiceAtual == 0
                    ? const Color(0xFF63D13E)
                    : Colors.white60,
              ),
              title: Text(
                'Início',
                style: TextStyle(
                  color: _indiceAtual == 0 ? Colors.white : Colors.white70,
                  fontWeight: _indiceAtual == 0 ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _mudarAba(0);
              },
            ),
            ListTile(
              selected: _indiceAtual == 1,
              selectedTileColor: const Color(0xFF1F1843),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: Icon(
                _indiceAtual == 1
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: _indiceAtual == 1
                    ? const Color(0xFF63D13E)
                    : Colors.white60,
              ),
              title: Text(
                'Favoritos',
                style: TextStyle(
                  color: _indiceAtual == 1 ? Colors.white : Colors.white70,
                  fontWeight: _indiceAtual == 1 ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _mudarAba(1);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.person_add_alt_1_rounded,
                color: Colors.white60,
              ),
              title: const Text(
                'Cadastro / Login',
                style: TextStyle(color: Colors.white70),
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
  final VoidCallback onAtivarLocalizacao;
  final bool carregandoLocalizacao;
  final bool posicaoAtiva;
  final List<Evento> eventos;

  const _InicioTab({
    required this.onAbrirEvento,
    required this.onPesquisar,
    required this.onAtivarLocalizacao,
    required this.carregandoLocalizacao,
    required this.posicaoAtiva,
    required this.eventos,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: 'Encontre os \n',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Colors.white,
              ),
              children: const [
                TextSpan(
                  text: 'melhores eventos\n',
                  style: TextStyle(
                    color: Color(0xFF63D13E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'em sua região \n',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                  'Ative sua localização e descubra eventos incríveis perto de você!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // Botão de Ativar Localização com Feedback de Carregamento
          SizedBox(
            width: 280,
            child: Material(
              color: const Color(0xFF63D13E),
              borderRadius: BorderRadius.circular(13),
              child: InkWell(
                onTap: carregandoLocalizacao ? null : onAtivarLocalizacao,
                borderRadius: BorderRadius.circular(13),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: carregandoLocalizacao
                      ? const Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2.5,
                      ),
                    ),
                  )
                      : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        posicaoAtiva
                            ? Icons.check_circle_rounded
                            : Icons.near_me_rounded,
                        color: Colors.black,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              posicaoAtiva
                                  ? 'Localização Ativa'
                                  : 'Ativar Localização',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              posicaoAtiva
                                  ? 'Eventos ordenados por proximidade'
                                  : 'Para ver eventos perto de você',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.black,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          _TituloSecao(
            titulo: 'Destaques para você',
            quantidade: eventos.length,
          ),
          const SizedBox(height: 12),

          if (eventos.isNotEmpty)
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