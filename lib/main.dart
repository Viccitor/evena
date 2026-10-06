import 'dart:async';
import 'dart:io';

import 'package:evena/screens/tela_home.dart';
import 'package:evena/services/auth_service.dart';
import 'package:evena/services/evento_service.dart';
import 'package:evena/services/favoritos_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.restaurarSessao();
  unawaited(EventoService.instance.carregar());
  unawaited(FavoritosService.instance.carregar());

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
    final base = ThemeData.dark().textTheme;
    final lato = GoogleFonts.latoTextTheme(base);
    final poppins = GoogleFonts.poppinsTextTheme(base);

    final textTheme = lato.copyWith(
      displayLarge: poppins.displayLarge,
      displayMedium: poppins.displayMedium,
      displaySmall: poppins.displaySmall,
      headlineLarge: poppins.headlineLarge,
      headlineMedium: poppins.headlineMedium,
      headlineSmall: poppins.headlineSmall,
      titleLarge: poppins.titleLarge,
      titleMedium: poppins.titleMedium,
      titleSmall: poppins.titleSmall,
      labelLarge: poppins.labelLarge,
      labelMedium: poppins.labelMedium,
      labelSmall: poppins.labelSmall,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evena',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F1A67),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF080427),
        textTheme: textTheme,
        primaryTextTheme: textTheme,
      ),
      home: const TelaHome(),
    );
  }
}
