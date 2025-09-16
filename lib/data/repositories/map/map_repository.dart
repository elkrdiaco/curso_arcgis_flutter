import 'package:arcgis_maps/arcgis_maps.dart' as arcgis;
import 'package:curso_arcgis_flutter/config/app_config.dart';

class MapRepository {
  arcgis.FeatureLayer getPobladosLayer() {
    final url = AppConfig().pobladosMargaritaUrl;
    return arcgis.FeatureLayer.withFeatureTable(
      arcgis.ServiceFeatureTable.withUri(Uri.parse(url)),
    );
  }
}