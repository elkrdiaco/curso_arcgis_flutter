import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  String get pobladosMargaritaUrl {
    return dotenv.env['URL_FEATURE_LAYER_POBLADOS_MARGARITA'] ?? '';
  }

  String get arcgisApiKey {
    return dotenv.env['ARCGIS_API_KEY'] ?? '';
  }
}