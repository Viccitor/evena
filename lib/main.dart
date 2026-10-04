import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:evena/screens/tela_home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evena/services/auth_service.dart';
import 'package:evena/services/favoritos_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.restaurarSessao();
  unawaited(FavoritosService.instance.carregar()); // sem travar a abertura

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
          seedColor: const Color(0xFF080427),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF080427),
        textTheme: GoogleFonts.latoTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const TelaHome(),
    );
  }
}