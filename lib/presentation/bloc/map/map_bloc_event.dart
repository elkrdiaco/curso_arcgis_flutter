part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

//Initialization and GPS toggle events
class MapInitialized extends MapEvent {}
class GpsToggled extends MapEvent {}

//Zoom events
class ZoomIn extends MapEvent {}
class ZoomOut extends MapEvent {}

//Created events for polygon editing
class StartPolygonEditing extends MapEvent {}
class SavePolygon extends MapEvent {}
class CancelEditing extends MapEvent {}