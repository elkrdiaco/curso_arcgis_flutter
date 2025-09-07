import 'package:arcgis_maps/arcgis_maps.dart' as arcgis;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapRepository {
  arcgis.FeatureLayer getPobladosLayer() {
    final uri = Uri.parse(dotenv.env['URL_FEATURE_LAYER_POBLADOS_MARGARITA'] ?? '');
    return arcgis.FeatureLayer.withFeatureTable(
      arcgis.ServiceFeatureTable.withUri(uri),
    );
  }
}