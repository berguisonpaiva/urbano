import 'package:get/get_connect/connect.dart';

class RestClient extends GetConnect {
  String? baseUrl = 'http://cootrapsfortaleza.com.br/webapp';
  RestClient() {
    httpClient.baseUrl = baseUrl;
  }
}

class RestClientException implements Exception {
  final int? code;
  final String message;
  RestClientException(
    this.message, {
    this.code,
  });

  @override
  String toString() => 'RestClientException(code: $code, message: $message)';
}
