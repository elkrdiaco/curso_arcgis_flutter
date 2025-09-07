import 'package:curso_arcgis_flutter/presentation/bloc/map/map_bloc.dart';
import 'package:curso_arcgis_flutter/presentation/pages/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arcgis_maps/arcgis_maps.dart';

void main() {
  ArcGISEnvironment.apiKey =
      "AAPTxy8BH1VEsoebNVZXo8HurDrMbswQ7-z03_OXCghR_byOjKZgBrBE9K1jg3oZkEJCNCLznay-I6yEG7lUeffRqNfT8noJzLAa9SDjf8fbd2MTD-OXbAvIcyIEtzQSrL2MZOE8_9--lmYhlAnDhSfm5kUmGdADvRvd4GEMmQy5VUMriEkMa4VXwys96I5g8Xj1KtykAPpS7wvfq9uPggRzfHd3WWfZxQvMupzojikGHW8.AT1_NW3f9jW3";

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
          ),
          child: const MapScreen(),
        )),
  );
}
