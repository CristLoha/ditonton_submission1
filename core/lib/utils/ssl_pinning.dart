import 'dart:io';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SSLPinning {
  static http.Client? _clientInstance;

  static http.Client get client => _clientInstance ?? http.Client();

  static Future<void> init() async {
    try {
      developer.log('🔐 Memuat sertifikat SSL...', name: 'SSLPinning');

      final sslCert = await rootBundle.load('certificates/certificates.pem');
      final context = SecurityContext(withTrustedRoots: false);
      context.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());

      final httpClient = HttpClient(context: context);
      httpClient.badCertificateCallback = (
        X509Certificate cert,
        String host,
        int port,
      ) {
        developer.log(
          '❌ Sertifikat tidak valid untuk $host',
          name: 'SSLPinning',
        );
        return host == 'developer.themoviedb.org';
      };

      _clientInstance = IOClient(httpClient);

      developer.log(
        '✅ SSL Pinning berhasil diinisialisasi',
        name: 'SSLPinning',
      );

      final response = await _clientInstance!.get(
        Uri.parse('https://developer.themoviedb.org/'),
      );

      if (response.statusCode == 200) {
        developer.log(
          '🌐 Koneksi berhasil ke developer.themoviedb.org, status code: ${response.statusCode}',
          name: 'SSLPinning',
        );
      } else {
        throw Exception('Failed to connect to TMDB API');
      }
    } catch (e, stack) {
      developer.log(
        '❗ Gagal inisialisasi SSL Pinning: $e',
        name: 'SSLPinning',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }
}
