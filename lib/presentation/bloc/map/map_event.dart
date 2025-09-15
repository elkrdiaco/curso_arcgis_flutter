part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

//Initialization and GPS toggle events
class MapInitialized extends MapEvent {
  final Brightness brightness;

  const MapInitialized(this.brightness);

  @override
  List<Object> get props => [brightness];
}

class UpdateBasemapStyle extends MapEvent {
  final Brightness brightness;

  const UpdateBasemapStyle(this.brightness);

  @override
  List<Object> get props => [brightness];
}
class GpsToggled extends MapEvent {}

//Created events for polygon editing
class StartPolygonEditing extends MapEvent {}
class StartPolylineEditing extends MapEvent {}
class StartPointEditing extends MapEvent {}
class SavePolygon extends MapEvent {}
class CancelEditing extends MapEvent {}

class MapTapped extends MapEvent {
  final Offset point;

  const MapTapped(this.point);

  @override
  List<Object> get props => [point];
}

class GraphicTapped extends MapEvent {
  final Graphic graphic;

  const GraphicTapped(this.graphic);

  @override
  List<Object> get props => [graphic];
}

class ToggleLayersList extends MapEvent {
  @override
  List<Object> get props => [];
}

class ToggleLayerVisibility extends MapEvent {
  final LayerInfo layer;
  const ToggleLayerVisibility(this.layer);
  @override
  List<Object> get props => [layer.name, layer.isVisible];
}

class UndoGeometryEditor extends MapEvent {}
class RedoGeometryEditor extends MapEvent {}

class ToggleSelectionMode extends MapEvent {}

// Evento que se dispara cuando el mapa ha terminado de renderizarse.
class MapRendered extends MapEvent {}