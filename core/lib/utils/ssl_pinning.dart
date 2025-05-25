import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SSLPinning {
  static http.Client? _clientInstance;
  static http.Client get client => _clientInstance ?? http.Client();

  static Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('certificates/certificates.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
    return securityContext;
  }

  static Future<http.Client> createClient() async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return IOClient(client);
  }

  static Future<void> init() async {
    try {
      _clientInstance = await createClient();

      await _clientInstance!.get(Uri.parse('https://themoviedb.org'));
    } on HandshakeException catch (e) {
      throw Exception('SSL Pinning HandshakeException: $e');
    } catch (e) {
      throw Exception('Failed to initialize SSL Pinning: $e');
    }
  }
}
