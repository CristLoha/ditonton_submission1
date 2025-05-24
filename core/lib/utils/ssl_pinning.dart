import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:io';

class SSLPinning {
  static Future<http.Client> get _instance async =>
      _clientInstance ??= await createLEClient();
  static http.Client? _clientInstance;
  static http.Client get client => _clientInstance ?? http.Client();

  static Future<void> init() async {
    try {
      developer.log('Initializing SSL Pinning...', name: 'SSLPinning');
      _clientInstance = await _instance;
      developer.log('SSL Pinning initialized successfully', name: 'SSLPinning');
    } catch (e) {
      developer.log(
        'SSL Pinning initialization failed: $e',
        name: 'SSLPinning',
        error: e,
      );
      rethrow;
    }
  }

  static Future<http.Client> createLEClient() async {
    SecurityContext context = SecurityContext(withTrustedRoots: true);

    try {
      developer.log('Loading certificate...', name: 'SSLPinning');
      final sslCert = await rootBundle.load('certificates/certificates.pem');
      developer.log('Certificate loaded successfully', name: 'SSLPinning');

      context.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
      developer.log('Certificate set to context', name: 'SSLPinning');
    } on TlsException catch (e) {
      if (e.osError?.message != null &&
          e.osError!.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
        developer.log('Certificate already trusted', name: 'SSLPinning');
      } else {
        developer.log(
          'TLS Exception: ${e.message}',
          name: 'SSLPinning',
          error: e,
        );
        rethrow;
      }
    } catch (e) {
      developer.log(
        'Certificate loading failed: $e',
        name: 'SSLPinning',
        error: e,
      );
      rethrow;
    }

    HttpClient httpClient = HttpClient(context: context);
    httpClient.badCertificateCallback = (
      X509Certificate cert,
      String host,
      int port,
    ) {
      developer.log('Invalid certificate for $host:$port', name: 'SSLPinning');
      return false;
    };

    return IOClient(httpClient);
  }
}
