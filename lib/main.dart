import 'package:curso_arcgis_flutter/presentation/pages/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:curso_arcgis_flutter/config/app_theme.dart';

Future<void> main() async {
  await dotenv.load();
  ArcGISEnvironment.apiKey = dotenv.env['ARCGIS_API_KEY'] ?? 'ARCGIS_API_KEY_TEXT';

  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: customLightTheme(),
      darkTheme: customDarkTheme(),
      themeMode: ThemeMode.system,
      home: const MapScreen(),
      );
  }
}
