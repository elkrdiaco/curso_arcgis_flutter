import 'package:curso_arcgis_flutter/presentation/bloc/map/map_bloc.dart';
import 'package:curso_arcgis_flutter/presentation/widgets/editing_controls.dart';
import 'package:curso_arcgis_flutter/presentation/widgets/gps_control_button.dart';
import 'package:curso_arcgis_flutter/presentation/widgets/map_app_bar.dart';
import 'package:curso_arcgis_flutter/presentation/widgets/layers_list_widget.dart';
import 'package:curso_arcgis_flutter/presentation/widgets/edit_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:curso_arcgis_flutter/data/repositories/map/map_repository.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapBloc _mapBloc;

  @override
  void initState() {
    super.initState();

    // --- Creación de Símbolos y Editor (se hace una sola vez) ---
    final vertexSymbol = SimpleMarkerSymbol(
      style: SimpleMarkerSymbolStyle.circle,
      color: Colors.blue,
      size: 20,
    );

    final selectedVertexSymbol = SimpleMarkerSymbol(
      style: SimpleMarkerSymbolStyle.circle,
      color: Colors.green.shade200,
      size: 20,
    );

    final geometryEditor = GeometryEditor();
    geometryEditor.tool.style.vertexSymbol = vertexSymbol;
    geometryEditor.tool.style.selectedVertexSymbol = selectedVertexSymbol;

    // Creación del BLoC con todo ya configurado
    _mapBloc = MapBloc(
      mapViewController: ArcGISMapView.createController(),
      geometryEditor: geometryEditor,
      mapRepository: MapRepository(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mapBloc,
      child: Scaffold(
        appBar: const MapAppBar(),
        body: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return Stack(
              children: [
                ArcGISMapView(
                  controllerProvider: () =>
                      _mapBloc.mapViewController,
                  onMapViewReady: () {
                    final brightness = Theme.of(context).brightness;
                    _mapBloc.add(MapInitialized(brightness));
                  },
                  onTap: (screenPoint) => context.read<MapBloc>().add(
                    MapTapped(Offset(screenPoint.dx, screenPoint.dy)),
                  ),
                ),
                if (state is MapLoadSuccess) ...[
                  Positioned(bottom: 40, right: 10, child: const EditFab()),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GpsControlButton(
                      isGpsEnabled: state.isGpsEnabled, 
                      showLayersList: state.showLayersList,
                      isSelectionModeActive: state.isSelectionModeActive,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                        'assets/images/logo_sica.png',
                        height: 35,
                      ),
                    ),
                  ),
                  EditingControls(isEditing: state.isEditing),
                  // Este ModalBarrier captura los toques fuera del panel de capas.
                  if (state.showLayersList)
                    ModalBarrier(
                      dismissible: true,
                      onDismiss: () {
                        context.read<MapBloc>().add(ToggleLayersList());
                      },
                      color: Colors.transparent, // Lo hacemos invisible
                    ),
                  if (state.showLayersList)
                    LayersListWidget(layers: state.layers),
                ] else ...[
                  const Center(child: LinearProgressIndicator()),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapBloc.close();
    super.dispose();
  }
}
