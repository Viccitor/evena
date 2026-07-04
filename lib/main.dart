import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
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
      title: 'evena App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'meu primeiro app'),
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
  bool _estaPesquisando = false;
  bool _foiFavoritado = false;
  int _indiceAtual = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080427),
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              child: Text("Menu"),
            ),
            ListTile(
              title: Text("Home"),
            ),
            ListTile(
              title: Text("Perfil"),
            ),
          ],
        ),
      ),
      appBar: AppBar( //Header
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        titleSpacing: 0,
        backgroundColor: const Color(0xFF01011D),

        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),


        title: _estaPesquisando
            ? Padding(
          padding: const EdgeInsets.only(right: 15),
          child: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Digitar pesquisa...',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
        )
            : Row(
          children: [
            Transform.translate(
              offset: const Offset(-25, 5),
              child: Image.asset(
                'assets/images/logo_evena_s_fundo.png',
                height: 130,
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(
                _estaPesquisando ? Icons.close : Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _estaPesquisando = !_estaPesquisando;
                });
              }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bem-vindo ao Evena!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Protótipo do app.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

           Row(
            children: [
            const Text(
                'Destaques para você',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              ),
            ),

              const Spacer(),

              BotaoVerMais(
                aoClicar: () {
                  print('Navegar para a tela de destaques');

                },
              )


            ],
           ),

            const SizedBox(height: 10),

            Container( //Container dos destaques ========================
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFF140E32),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/evento1.jpg',
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),


                      Positioned(
                        top: 8,
                        left: 8,


                        child: IconButton(
                          onPressed: () {

                            setState(() {
                              _foiFavoritado = !_foiFavoritado;
                            });
                            print('Botão de dentro da imagem clicado');
                          },
                          icon: Icon(

                            _foiFavoritado ? Icons.favorite : Icons.favorite_border,

                            color: _foiFavoritado ? Color(0xFF65D13E) : Colors.white,
                            size: 16,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            minimumSize: const Size(32, 32),
                            padding: EdgeInsets.zero,
                            shape: const CircleBorder(),
                          ),
                        )
                      ),
                    ],
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container( // container data===========
                              width: 37,
                              height: 45,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: const Color(0xFF140B38),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: const Color(0xFF7C2BDC),
                                  width: 1,
                                ),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '24',
                                      style: TextStyle(
                                        color: Color(0xFF7C2BDC),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        height: 1.1,
                                      ),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      'FEV',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        height: 1.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            const Expanded(
                              child: Text(
                                'Evento de Marketing Digital',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        const Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Color(0xFF8E68CD),
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              '19:00',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white70),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),


                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFF8E68CD),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            const Expanded(
                              child: Text(
                                'Hotel Trânsilvânia São Paulo - SP',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white70),
                              ),
                            ),

                            const SizedBox(width: 5),

                            IconButton(
                              onPressed: () {
                                print('Botão do card clicado!');
                              },
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 12,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFF251660),
                                minimumSize: const Size(30, 30),
                                padding: EdgeInsets.zero,
                                shape: const CircleBorder(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),
          Row(
            children: [
            const Text('Categorias',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            ),

            const Spacer(),

            BotaoVerMais(
              aoClicar: () {
                print('Navegar para a tela de todas as categorias');

              },
            ),
          ],
      ),

            SizedBox(height: 10),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,


            child: Row(
              children: const [

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
                  caminhoImagem: 'assets/images/educacao.png',
                  texto: 'Educação',
                ),
                SizedBox(width: 10),
                CardCategoria(
                  caminhoImagem: 'assets/images/infantil.png',
                  texto: 'Infantil',
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
                SizedBox(width: 10),
                CardCategoria(
                  caminhoImagem: 'assets/images/esportes.png',
                  texto: 'Esportes',
                ),
                SizedBox(width: 10),
                CardCategoria(
                  caminhoImagem: 'assets/images/games.png',
                  texto: 'Workshop',
                ),
                SizedBox(width: 10),




              ],
            )
          )

          ],
        ),
      ),
    );
  }
}

class CardCategoria extends StatelessWidget { //classe dos cards da categoria
  final String caminhoImagem;
  final String texto;


  const CardCategoria({
    super.key,
    required this.caminhoImagem,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1B0F3F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                height: 40,
                caminhoImagem,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            texto,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w200,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

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