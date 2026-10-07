class ApiConfig {
  static String get baseUrl {
    const definida = String.fromEnvironment('API_URL');

    if (definida.trim().isNotEmpty) {
      var url = definida.trim();

      while (url.endsWith('/')) {
        url = url.substring(0, url.length - 1);
      }

      if (!url.endsWith('/api')) {
        url = '$url/api';
      }

      return url;
    }

    return 'https://evena-api-dedbaudqbjcegyfn.chilecentral-01.azurewebsites.net/api';
  }
}
