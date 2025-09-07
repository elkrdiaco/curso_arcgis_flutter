import 'package:curso_arcgis_flutter/presentation/bloc/map/map_bloc.dart';
import 'package:curso_arcgis_flutter/presentation/widgets/gps_control_button.dart';
import 'package:curso_arcgis_flutter/presentation/widgets/map_app_bar.dart';
import 'package:curso_arcgis_flutter/presentation/widgets/edit_fab.dart';
import 'package:curso_arcgis_flutter/presentation/widgets/zoom_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arcgis_maps/arcgis_maps.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void dispose() {
    // El BLoC ahora es responsable del controlador.
    context.read<MapBloc>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MapAppBar(),
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          return Stack(
            children: [
              ArcGISMapView(
                  controllerProvider: () =>
                      context.read<MapBloc>().mapViewController,
                  onMapViewReady: () =>
                      context.read<MapBloc>().add(MapInitialized())),
              if (state is MapLoadSuccess) ...[
                Positioned(
                  bottom: 40,
                  right: 10,
                  child: const ZoomControls(),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: const EditFab(),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GpsControlButton(
                    isGpsEnabled: state.isGpsEnabled,
                  ),
                ),
              ] else ...[
                const Center(child: LinearProgressIndicator()),
              ]
            ],
          );
        },
      ),
    );
  }
}