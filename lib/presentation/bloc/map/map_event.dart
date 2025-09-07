part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

//Initialization and GPS toggle events
class MapInitialized extends MapEvent {}
class GpsToggled extends MapEvent {}

//Created events for polygon editing
class StartPolygonEditing extends MapEvent {}
class SavePolygon extends MapEvent {}
class CancelEditing extends MapEvent {}

class MapTapped extends MapEvent {
  final Offset point;

  const MapTapped(this.point);

  @override
  List<Object> get props => [point];
}

class GraphicTapped extends MapEvent {
  final arcgis.Graphic graphic;

  const GraphicTapped(this.graphic);

  @override
  List<Object> get props => [graphic];
}

class UndoGeometryEditor extends MapEvent {}
class RedoGeometryEditor extends MapEvent {}