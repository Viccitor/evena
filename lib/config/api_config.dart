
class ApiConfig {
  static String get baseUrl {
    const definida = String.fromEnvironment('API_URL');

    if (definida.isNotEmpty) {
      return definida.endsWith('/api') ? definida : '$definida/api';
    }

    return 'https://evena-api-dedbaudqbjcegyfn.chilecentral-01.azurewebsites.net/api';
  }
}