

import 'package:flutter/material.dart';

class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  //Controlador para saber qual página está ativa
  int _paginaAtual = 0;
  final PageController _pageController = PageController();

  //Lista com os textos de cada slide
  final List<Map<String, String>> _slides = [
    {
      'tituloBranco': 'Conectando pessoas\n',
      'tituloVerde': 'a experiências inesquecíveis.',
      'subtitulo': 'Descubra, organize e viva os melhores eventos da sua região.',
    },
    {
      'tituloBranco': 'Sua agenda cheia de\n',
      'tituloVerde': 'momentos incríveis.',
      'subtitulo': 'Garanta seu ingresso e não perca nenhum festival ou show.',
    },
    {
      'tituloBranco': 'Conecte-se com quem\n',
      'tituloVerde': 'curte o mesmo som.',
      'subtitulo': 'Crie memórias e compartilhe experiências com seus amigos.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000010),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Imagem do topo
            SizedBox(
              width: double.infinity,
              child: Image.asset(
                'assets/images/imagem_cadastro.png',
                height: 320,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),


            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _paginaAtual = index;
                  });
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Column(
                    children: [
                      // Título principal
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 34.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(text: slide['tituloBranco']),
                              TextSpan(
                                text: slide['tituloVerde'],
                                style: const TextStyle(
                                  color: Color(0xFF63D13E),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Subtítulo
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Text(
                          slide['subtitulo']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 0),

            //Indicador de Bolinhas (Dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 7.0),
                  height: 8,
                  width: _paginaAtual == index ? 8 : 8,
                  decoration: BoxDecoration(
                    color: _paginaAtual == index
                        ? const Color(0xFF63D13E)
                          : const Color(0xFF3B1E78),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Padding( //botão começar
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      print('Botão Clicado');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5CD825),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),



                    child: const Row(//botão ja tenho conta
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width:20),

                        Text(
                          'Começar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      ]

                    )


                  ),
                ),
            ),

            SizedBox(height: 20),

            Padding( //botão ja tenho conta
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      print('Botão Clicado');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000010),
                      foregroundColor: const Color(0XFFA62CFB),
                      elevation: 0,
                      side: const BorderSide(
                        color: Color(0XFFA62CFB),
                        width: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),


                          child: const Text(
                            'Já tenho uma conta',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              
                            ),
                          ),
                    )
                ),
              ),

            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
}