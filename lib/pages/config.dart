import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentConfig {
  // Toggle this flag to switch local vs production backend.
  static const bool isDevelopment = false;

  static String get _productionBaseUrl => dotenv.env['PRODUCTION_BASE_URL']?.trim() ?? '';

  static const String _localAndroidBaseUrl = 'http://10.0.2.2:8000';

  static String get baseUrl =>
      isDevelopment ? _localAndroidBaseUrl : _productionBaseUrl;

  static Uri get baseUri => Uri.parse(baseUrl);

  static Uri endpoint(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return baseUri.resolve(normalizedPath);
  }
}
