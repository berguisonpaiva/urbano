

import 'package:get/get.dart';

class RestClient extends GetConnect {
  
  RestClient() {
    httpClient.baseUrl = 'http://cootrapsfortaleza.com.br';
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
