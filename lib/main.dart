import 'package:curso_arcgis_flutter/data/repositories/map/map_repository.dart';
import 'package:curso_arcgis_flutter/presentation/bloc/map/map_bloc.dart';
import 'package:curso_arcgis_flutter/presentation/pages/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  ArcGISEnvironment.apiKey = dotenv.env['ARCGIS_API_KEY'] ?? 'ARCGIS_API_KEY_TEXT';

  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade900),
          useMaterial3: true,
        ),
        home: BlocProvider(
          create: (context) => MapBloc(
            mapViewController: ArcGISMapView.createController(),
            geometryEditor: GeometryEditor(),
            mapRepository: MapRepository()
          ),
          child: const MapScreen(),
        )),
  );
}
