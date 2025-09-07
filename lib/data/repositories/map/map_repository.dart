import 'package:arcgis_maps/arcgis_maps.dart' as arcgis;

class MapRepository {
  arcgis.FeatureLayer getPobladosLayer() {
    final uri = Uri.parse('https://services5.arcgis.com/xZWz93fd6IlyKPjJ/arcgis/rest/services/Centros_Poblados_Margarita/FeatureServer/2');
    return arcgis.FeatureLayer.withFeatureTable(
      arcgis.ServiceFeatureTable.withUri(uri),
    );
  }
}