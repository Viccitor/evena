import 'dart:convert';

import 'package:evena/config/api_config.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String mensagem;

  const ApiException(this.mensagem);

  @override
  String toString() => mensagem;
}

class ApiService {
  static Uri _uri(String caminho, [Map<String, String>? query]) {
    return Uri.parse(
      '${ApiConfig.baseUrl}$caminho',
    ).replace(queryParameters: query);
  }

  static Future<dynamic> get(
    String caminho, {
    Map<String, String>? query,
  }) async {
    final response = await http
        .get(_uri(caminho, query))
        .timeout(const Duration(seconds: 15));

    return _tratar(response);
  }

  static Future<dynamic> post(
    String caminho, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http
        .post(
          _uri(caminho),
          headers: const {'Content-Type': 'application/json'},
          body: body == null ? null : jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));

    return _tratar(response);
  }

  static Future<dynamic> put(
    String caminho, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http
        .put(
          _uri(caminho),
          headers: const {'Content-Type': 'application/json'},
          body: body == null ? null : jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));

    return _tratar(response);
  }

  static Future<dynamic> patch(
    String caminho, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http
        .patch(
          _uri(caminho),
          headers: const {'Content-Type': 'application/json'},
          body: body == null ? null : jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));

    return _tratar(response);
  }

  static Future<dynamic> delete(String caminho) async {
    final response = await http
        .delete(_uri(caminho))
        .timeout(const Duration(seconds: 15));

    return _tratar(response);
  }

  static dynamic _tratar(http.Response response) {
    dynamic data;

    if (response.body.isNotEmpty) {
      data = jsonDecode(utf8.decode(response.bodyBytes));
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    if (data is Map<String, dynamic> && data['erro'] != null) {
      throw ApiException(data['erro'].toString());
    }

    throw ApiException('Não foi possível concluir a operação.');
  }
}
