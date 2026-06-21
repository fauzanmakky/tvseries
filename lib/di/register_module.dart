import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @preResolve
  @lazySingleton
  Future<http.Client> get httpClient async {
    final cert = await rootBundle.load(
      'assets/certificates/themoviedb.org.pem',
    );
    final context = SecurityContext(withTrustedRoots: false);
    context.setTrustedCertificatesBytes(cert.buffer.asUint8List());
    final client = HttpClient(context: context)
      ..badCertificateCallback = (cert, host, port) => false;
    return IOClient(client);
  }
}
