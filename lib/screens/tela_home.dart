import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:evena/models/evento.dart';
import 'package:evena/components/card_evento.dart';
import 'package:evena/components/cards_categoria.dart';
import 'package:evena/screens/tela_detalhe_evento.dart';
import 'package:evena/screens/tela_inicio.dart';
import 'package:evena/screens/tela_pesquisa.dart';
import 'package:evena/screens/tela_favoritos.dart';
import 'package:evena/screens/tela_perfil.dart';
import 'package:evena/services/auth_service.dart';
import 'package:evena/data/categorias_data.dart';
import 'package:evena/screens/tela_organizador.dart';
import 'package:evena/screens/tela_admin.dart';
import 'package:evena/services/evento_service.dart';

class TelaHome extends StatefulWidget {
  const TelaHome({super.key});

  @override
  State<TelaHome> createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  int _indiceAtual = 0;
  late final PageController _pageController;

  final EventoService _eventoService = EventoService.instance;
  List<Evento> _listaEventos = const [];
  bool _carregandoLocalizacao = false;
  Position? _posicaoAtual;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _indiceAtual);
    _eventoService.addListener(_sincronizarEventos);
    AuthService.perfilListenable.addListener(_sincronizarAcessoAdmin);
    _sincronizarEventos();
    if (_eventoService.eventos.isEmpty) {
      _eventoService.carregar();
    }
    _ativarLocalizacaoSilenciosa();
  }

  @override
  void dispose() {
    _eventoService.removeListener(_sincronizarEventos);
    AuthService.perfilListenable.removeListener(_sincronizarAcessoAdmin);
    _pageController.dispose();
    super.dispose();
  }


  void _sincronizarAcessoAdmin() {
    if (!mounted) return;
    if (!AuthService.ehAdmin && _indiceAtual > 2) {
      _indiceAtual = 0;
      if (_pageController.hasClients) _pageController.jumpToPage(0);
    }
    setState(() {});
  }

  void _sincronizarEventos() {
    if (!mounted) return;
    final atualizados = List<Evento>.from(_eventoService.eventos);
    if (_posicaoAtual != null) {
      _ordenarPorProximidade(atualizados, _posicaoAtual!);
    }
    setState(() => _listaEventos = atualizados);
  }

  void _ordenarPorProximidade(List<Evento> lista, Position position) {
    lista.sort((a, b) {
      if (a.online != b.online) return a.online ? 1 : -1;
      if (a.online && b.online) return a.inicio.compareTo(b.inicio);

      final distA = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        a.latitude,
        a.longitude,
      );
      final distB = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        b.latitude,
        b.longitude,
      );
      return distA.compareTo(distB);
    });
  }

  /// Tenta obter a localização sem forçar pop-up se já tiver permissão concedida
  Future<void> _ativarLocalizacaoSilenciosa() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        _obterLocalizacaoEOrdenar();
      }
    } catch (_) {}
  }

  /// Solicita permissão e ordena a lista de eventos do mais próximo ao mais distante
  Future<void> _solicitarEObterLocalizacao() async {
    setState(() => _carregandoLocalizacao = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ative o GPS do seu dispositivo.')),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Permissão de localização negada.')),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permissão permanentemente negada nas configurações.'),
            ),
          );
        }
        return;
      }

      await _obterLocalizacaoEOrdenar();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao obter localização: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _carregandoLocalizacao = false);
      }
    }
  }

  Future<void> _obterLocalizacaoEOrdenar() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    final eventosOrdenados = List<Evento>.from(_eventoService.eventos);
    _ordenarPorProximidade(eventosOrdenados, position);

    if (mounted) {
      setState(() {
        _posicaoAtual = position;
        _listaEventos = eventosOrdenados;
      });
    }
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

  void _abrirCategoria(String categoria) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TelaPesquisa(categoriaInicial: categoria),
      ),
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
    final ehAdmin = AuthService.ehAdmin;
    final paginas = [
      _InicioTab(
        onAbrirCategoria: _abrirCategoria,
        onAbrirEvento: _abrirEvento,
        eventos: _listaEventos,
        posicaoAtual: _posicaoAtual,
        carregandoLocalizacao: _carregandoLocalizacao,
        onSolicitarLocalizacao: _solicitarEObterLocalizacao,
      ),
      FavoritosTab(onAbrirEvento: _abrirEvento),
      const PerfilTab(),
      if (ehAdmin) const TelaAdmin(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF080427),
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF080427),
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: -12,
        title: InkWell(
          onTap: () => _mudarAba(0),
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/logo_evena_s_fundo.png',
            height: 120,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          if (_indiceAtual != 2 && _indiceAtual != 3)
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
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white54),
              selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF63D13E)),
              label: 'Início',
            ),
            const NavigationDestination(
              icon: Icon(Icons.favorite_border_rounded, color: Colors.white54),
              selectedIcon: Icon(
                Icons.favorite_rounded,
                color: Color(0xFF63D13E),
              ),
              label: 'Favoritos',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline_rounded, color: Colors.white54),
              selectedIcon: Icon(
                Icons.person_rounded,
                color: Color(0xFF63D13E),
              ),
              label: 'Perfil',
            ),
            if (ehAdmin)
              const NavigationDestination(
                icon: Icon(
                  Icons.admin_panel_settings_outlined,
                  color: Colors.white54,
                ),
                selectedIcon: Icon(
                  Icons.admin_panel_settings_rounded,
                  color: Color(0xFF00FF00),
                ),
                label: 'Admin',
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
        child: Column( // 1. Usamos Column para poder controlar o topo e o fundo
          children: [
            // --- TOPO E NAVEGAÇÃO SUPERIOR ---
            Expanded( // 2. O Expanded força esta lista a ocupar o espaço livre no meio
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _mudarAba(0);
                    },
                    child: Padding(
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
                      Icons.add_circle_outline_rounded,
                      color: Color(0xFF63D13E),
                    ),
                    title: const Text(
                      'Criar evento',
                      style: TextStyle(color: Colors.white70),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TelaOrganizador(),
                        ),
                      );
                    },
                  ),

                  ValueListenableBuilder(
                    valueListenable: AuthService.perfilListenable,
                    builder: (context, perfil, _) {
                      if (perfil != null) return const SizedBox.shrink();

                      return ListTile(
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
                            MaterialPageRoute(
                              builder: (_) => const TelaInicio(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            // --- RODAPÉ (FIXO EMBAIXO) ---
            ValueListenableBuilder(
              valueListenable: AuthService.perfilListenable,
              builder: (context, perfil, _) {

                if (perfil == null) return const SizedBox.shrink();

                return Column(
                  children: [
                    const Divider(color: Colors.white12, height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading:
                        const Icon(Icons.logout, color: Colors.redAccent),
                        title: const Text(
                          'Sair',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () async {
                          await AuthService.sair();

                          if (!context.mounted) return;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TelaHome(),
                            ),
                                (route) => false,
                          );
                        },
                      ),
                    ),
                  ],
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
  final List<Evento> eventos;
  final Position? posicaoAtual;
  final bool carregandoLocalizacao;
  final VoidCallback onSolicitarLocalizacao;
  final ValueChanged<String> onAbrirCategoria;

  const _InicioTab({
    required this.onAbrirEvento,
    required this.eventos,
    required this.posicaoAtual,
    required this.carregandoLocalizacao,
    required this.onSolicitarLocalizacao,
    required this.onAbrirCategoria,
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
                    color: Color(0xFF00FF00),
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
                  text: 'Descubra experiências incríveis perto de você!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // --- BOTÃO DE LOCALIZAÇÃO (GPS) RESTAURADO ---
          InkWell(
            onTap: carregandoLocalizacao ? null : onSolicitarLocalizacao,
            borderRadius: BorderRadius.circular(16),
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF140E32),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF7C2BDC).withValues(alpha: .35),
                ),
              ),
              child: Row(
                children: [
                  carregandoLocalizacao
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF63D13E),
                    ),
                  )
                      : Icon(
                    posicaoAtual != null
                        ? Icons.my_location_rounded
                        : Icons.location_on_rounded,
                    color: const Color(0xFF63D13E),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      posicaoAtual != null
                          ? 'Eventos ordenados por proximidade'
                          : 'Usar minha localização para ver eventos próximos',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (posicaoAtual == null && !carregandoLocalizacao)
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white54,
                      size: 14,
                    ),
                ],
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

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final categoria in categoriasEventos) ...[
                  CardCategoria(
                    caminhoImagem: categoria.imagem,
                    texto: categoria.nome,
                    onTap: () => onAbrirCategoria(categoria.nome),
                  ),
                  const SizedBox(width: 10),
                ],
              ],
            ),
          ),


          const SizedBox(height: 20),

          const Text(
            'Próximos eventos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),

          // Se só houver 1 ou nenhum evento, não tenta pular o primeiro
          if (eventos.length > 1)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: eventos.length - 1,
              itemBuilder: (context, index) {
                // index + 1 para pular o primeiro evento que já está em destaque
                final evento = eventos[index + 1];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CardEvento(
                    evento: evento,
                    compacto: true,
                    onTap: () => onAbrirEvento(evento),
                  ),
                );
              },
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