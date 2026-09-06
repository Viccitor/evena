import 'dart:io';

import 'package:evena/components/card_evento.dart';
import 'package:evena/components/cards_categoria.dart';
import 'package:evena/models/evento.dart';
import 'package:evena/screens/tela_detalhe_evento.dart';
import 'package:evena/screens/tela_inicio.dart';
import 'package:evena/screens/tela_pesquisa.dart';
import 'package:evena/services/auth_service.dart';
import 'package:evena/services/evento_service.dart';
import 'package:evena/services/favoritos_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      size: Size(390, 844),
      center: true,
      title: 'Evena',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evena',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF63D13E),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF080427),
      ),
      home: const MyHomePage(title: 'Evena'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _indiceAtual = 0;

  @override
  void initState() {
    super.initState();
    EventoService.instance.carregar();
    FavoritosService.instance.carregar();
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

  @override
  Widget build(BuildContext context) {
    final paginas = [
      _InicioTab(onAbrirEvento: _abrirEvento, onPesquisar: _abrirPesquisa),
      _FavoritosTab(onAbrirEvento: _abrirEvento),
      const _PerfilTab(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF080427),
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF01011D),
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: Image.asset('assets/images/logo_evena_s_fundo.png', height: 88),
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
              return const TextStyle(
                color: Color(0xFF63D13E),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              );
            }

            return const TextStyle(color: Colors.white54, fontSize: 11);
          }),
        ),
        child: NavigationBar(
          selectedIndex: _indiceAtual,
          height: 68,
          backgroundColor: const Color(0xFF181236),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) {
            setState(() => _indiceAtual = index);
          },
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
              child: Image.asset(
                'assets/images/logo_evena_s_fundo.png',
                height: 100,
                alignment: Alignment.centerLeft,
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
              title: Text(
                AuthService.estaLogado ? 'Minha conta' : 'Cadastro / Login',
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);

                if (AuthService.estaLogado) {
                  setState(() => _indiceAtual = 2);
                  return;
                }

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
    final service = EventoService.instance;

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        if (service.carregando && service.eventos.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF63D13E)),
          );
        }

        if (service.erro != null && service.eventos.isEmpty) {
          return _ErroApi(
            mensagem: service.erro!,
            onTentarNovamente: service.carregar,
          );
        }

        final eventos = service.eventos;

        if (eventos.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum evento disponível.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: service.carregar,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bem-vindo ao Evena!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Descubra experiências para viver de verdade.',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
                const SizedBox(height: 18),
                InkWell(
                  onTap: onPesquisar,
                  borderRadius: BorderRadius.circular(16),
                  child: Ink(
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF140E32),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF7C2BDC).withValues(alpha: .35),
                      ),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 15),
                        Icon(Icons.search_rounded, color: Color(0xFF63D13E)),
                        SizedBox(width: 10),
                        Text(
                          'Pesquisar eventos...',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 26),
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
          ),
        );
      },
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

class _FavoritosTab extends StatelessWidget {
  final ValueChanged<Evento> onAbrirEvento;

  const _FavoritosTab({required this.onAbrirEvento});

  @override
  Widget build(BuildContext context) {
    final favoritos = FavoritosService.instance;
    final eventoService = EventoService.instance;

    return ListenableBuilder(
      listenable: Listenable.merge([favoritos, eventoService]),
      builder: (context, _) {
        final lista = eventoService.eventos
            .where((evento) => favoritos.contem(evento.id))
            .toList();

        if (lista.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(34),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.white24,
                    size: 68,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum favorito ainda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Toque no coração de um evento e ele aparecerá aqui.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, height: 1.4),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          itemCount: lista.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final evento = lista[index];

            return CardEvento(
              evento: evento,
              compacto: true,
              onTap: () => onAbrirEvento(evento),
            );
          },
        );
      },
    );
  }
}

class _PerfilTab extends StatelessWidget {
  const _PerfilTab();

  @override
  Widget build(BuildContext context) {
    final perfil = AuthService.perfilAtual;

    if (perfil == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 42,
                backgroundColor: Color(0xFF1D1544),
                child: Icon(
                  Icons.person_rounded,
                  color: Color(0xFF63D13E),
                  size: 46,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Você ainda não entrou',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TelaInicio()),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF63D13E),
                  foregroundColor: Colors.black,
                ),
                child: const Text('Entrar ou criar conta'),
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 42,
              backgroundColor: Color(0xFF1D1544),
              child: Icon(
                Icons.person_rounded,
                color: Color(0xFF63D13E),
                size: 46,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              perfil.nome,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Text(perfil.email, style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 22),
            OutlinedButton(
              onPressed: () {
                AuthService.sair();
                FavoritosService.instance.limpar();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyHomePage(title: 'Evena'),
                  ),
                  (route) => false,
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF7C2BDC)),
              ),
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErroApi extends StatelessWidget {
  final String mensagem;
  final Future<void> Function() onTentarNovamente;

  const _ErroApi({required this.mensagem, required this.onTentarNovamente});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Colors.white30,
              size: 58,
            ),
            const SizedBox(height: 14),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onTentarNovamente,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF63D13E),
                foregroundColor: Colors.black,
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
