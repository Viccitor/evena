import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    const definida = String.fromEnvironment('API_URL');

    if (definida.isNotEmpty) {
      return definida.endsWith('/api') ? definida : '$definida/api';
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080/api';
    }

    return 'http://localhost:8080/api';
  }
}
