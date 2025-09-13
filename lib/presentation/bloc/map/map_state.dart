part of 'map_bloc.dart';

class LayerInfo extends Equatable {
  final String name;
  final dynamic layerObject;

  const LayerInfo({required this.name, required this.layerObject, this.isVisible = true});

  final bool isVisible;

  LayerInfo copyWith({bool? isVisible}) {
    return LayerInfo(
      name: name,
      layerObject: layerObject,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  List<Object> get props => [name, layerObject, isVisible];
}

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

// Estado inicial, antes de que el mapa se haya cargado.
class MapInitial extends MapState {}

// Estado que indica que el mapa se cargó correctamente.
// Contiene las propiedades que la UI necesita para dibujarse.
class MapLoadSuccess extends MapState {
  final bool isGpsEnabled;
  final bool isEditing;
  final List<LayerInfo> layers;
  final bool showLayersList;
  final bool isSelectionModeActive;

  const MapLoadSuccess({
    this.isGpsEnabled = false, 
    this.isEditing = false, 
    this.layers = const [],
    this.showLayersList = false,
    this.isSelectionModeActive = false,
  });

  // Método para crear una copia del estado actual con valores modificados.
  MapLoadSuccess copyWith({
    bool? isGpsEnabled,
    bool? isEditing,
    List<LayerInfo>? layers,
    bool? showLayersList,
    bool? isSelectionModeActive,
  }) {
    return MapLoadSuccess(
      isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
      isEditing: isEditing ?? this.isEditing,
      layers: layers ?? this.layers,
      showLayersList: showLayersList ?? this.showLayersList,
      isSelectionModeActive: isSelectionModeActive ?? this.isSelectionModeActive,
    );
  }
  @override
  List<Object> get props => [isGpsEnabled, isEditing, layers, showLayersList, isSelectionModeActive];
}