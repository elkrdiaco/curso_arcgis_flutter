part of 'map_bloc.dart';

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

  const MapLoadSuccess({this.isGpsEnabled = false, this.isEditing = false});

  // Método para crear una copia del estado actual con valores modificados.
  MapLoadSuccess copyWith({
    bool? isGpsEnabled,
    bool? isEditing,
  }) {
    return MapLoadSuccess(
      isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
      isEditing: isEditing ?? this.isEditing,
    );
  }
  @override
  List<Object> get props => [isGpsEnabled, isEditing];
}