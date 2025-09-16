import 'package:arcgis_maps/arcgis_maps.dart' as arcgis;
import 'package:curso_arcgis_flutter/config/app_config.dart';

class MapRepository {
  final AppConfig _appConfig;

  // El repositorio ahora recibe su configuración, en lugar de crearla.
  MapRepository({AppConfig? appConfig}) : _appConfig = appConfig ?? AppConfig();

  arcgis.FeatureLayer getPobladosLayer() {
    final url = _appConfig.pobladosMargaritaUrl;
    return arcgis.FeatureLayer.withFeatureTable(
      arcgis.ServiceFeatureTable.withUri(Uri.parse(url)),
    );
  }
}