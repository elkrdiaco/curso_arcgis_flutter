// lib/bloc/map_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:curso_arcgis_flutter/data/repositories/map/map_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:arcgis_maps/arcgis_maps.dart' as arcgis;
import 'package:flutter/material.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  arcgis.ArcGISMapViewController mapViewController;
  arcgis.GeometryEditor geometryEditor;
  final _graphicsOverlay = arcgis.GraphicsOverlay();
  final MapRepository mapRepository;
  arcgis.Graphic? _originalGraphicBeingEdited; // To store the graphic being edited

  MapBloc({
    required this.mapViewController, 
    required this.geometryEditor,
    required this.mapRepository,
  }) : super(MapInitial()) {
    on<MapInitialized>(_onMapInitialized);
    on<GpsToggled>(_onGpsToggled);

    on<StartPolygonEditing>(_onStartPolygonEditing);
    on<SavePolygon>(_onSavePolygon);
    on<CancelEditing>(_onCancelEditing);
    on<MapTapped>(_onMapTapped);
    on<GraphicTapped>(_onGraphicTapped);
    on<UndoGeometryEditor>(_onUndoGeometryEditor);
    on<RedoGeometryEditor>(_onRedoGeometryEditor);
  }

  // Maneja el evento de inicialización del mapa.
  Future<void> _onMapInitialized(
    MapInitialized event,
    Emitter<MapState> emit,
  ) async {
    final map = arcgis.ArcGISMap.withBasemapStyle(
      arcgis.BasemapStyle.openStreets,
    );
    map.operationalLayers.add(mapRepository.getPobladosLayer());
    mapViewController.locationDisplay.dataSource = arcgis.SystemLocationDataSource();
    mapViewController.arcGISMap = map;
    mapViewController.setViewpoint(
      arcgis.Viewpoint.withLatLongScale(
        latitude: 34.02700,
        longitude: -118.80500,
        scale: 72000,
      ),
    );

    mapViewController.geometryEditor ??= geometryEditor;

    // Clear existing graphics overlays before adding the one managed by the BLoC
    mapViewController.graphicsOverlays.clear(); // <--- Added this line
    mapViewController.graphicsOverlays.add(_graphicsOverlay); // <--- Removed conditional check

    // Emite el estado de éxito una vez que el mapa está configurado.
    emit(const MapLoadSuccess(isGpsEnabled: false));
  }

  // Maneja el evento para activar/desactivar el GPS.
  void _onGpsToggled(
    GpsToggled event,
    Emitter<MapState> emit,
  ) {
    if (state is MapLoadSuccess) {
      final currentState = state as MapLoadSuccess;
      final locationDisplay = mapViewController.locationDisplay;

      if (locationDisplay.autoPanMode == arcgis.LocationDisplayAutoPanMode.off) {
        locationDisplay.autoPanMode = arcgis.LocationDisplayAutoPanMode.recenter;
        locationDisplay.start();
        emit(currentState.copyWith(isGpsEnabled: true));
      } else {
        locationDisplay.autoPanMode = arcgis.LocationDisplayAutoPanMode.off;
        locationDisplay.stop();
        emit(currentState.copyWith(isGpsEnabled: false));
      }
    }
  }

  void _onStartPolygonEditing(StartPolygonEditing event, Emitter<MapState> emit) {
    if (state is MapLoadSuccess) {
      if (geometryEditor.isStarted) {
        geometryEditor.stop();
        _graphicsOverlay.graphics.clear(); // Clear any previous edited graphic
      }
      geometryEditor.startWithGeometryType(arcgis.GeometryType.polygon);
      emit((state as MapLoadSuccess).copyWith(isEditing: true));
    }
  }

  void _onSavePolygon(SavePolygon event, Emitter<MapState> emit) {
    if (state is MapLoadSuccess) {
      final geometry = geometryEditor.geometry;
      if (geometry == null) {
        geometryEditor.stop();
        emit((state as MapLoadSuccess).copyWith(isEditing: false));
        return;
      }

      final polygonSymbol = arcgis.SimpleFillSymbol(
        style: arcgis.SimpleFillSymbolStyle.solid,
        color: Colors.red.withAlpha(127),
        outline: arcgis.SimpleLineSymbol(
          style: arcgis.SimpleLineSymbolStyle.solid,
          color: Colors.red,
          width: 2,
        ),
      );

      // If editing an existing graphic, update its geometry. Otherwise, create a new one.
      if (_graphicsOverlay.graphics.isNotEmpty && geometryEditor.geometry != null) {
          final existingGraphic = _graphicsOverlay.graphics.first;
          existingGraphic.geometry = geometry;
      } else {
          final graphic = arcgis.Graphic(
              geometry: geometry,
              symbol: polygonSymbol,
          );
          _graphicsOverlay.graphics.add(graphic);
      }

      _originalGraphicBeingEdited = null; // Clear the reference after saving

      geometryEditor.stop();
      emit((state as MapLoadSuccess).copyWith(isEditing: false));
    }
  }

  void _onCancelEditing(CancelEditing event, Emitter<MapState> emit) {
    if (state is MapLoadSuccess) {
      geometryEditor.stop();
      _graphicsOverlay.graphics.clear(); // Clear the graphic being edited/drawn

      if (_originalGraphicBeingEdited != null) {
        // If we were editing an existing graphic, restore it
        _graphicsOverlay.graphics.add(_originalGraphicBeingEdited!); // Restore the original graphic
        _originalGraphicBeingEdited = null; // Clear the reference
      }
      // If _originalGraphicBeingEdited is null, it means we were drawing a new one,
      // and _graphicsOverlay.graphics.clear() already handled it.

      emit((state as MapLoadSuccess).copyWith(isEditing: false));
    }
  }

  Future<void> _onMapTapped(MapTapped event, Emitter<MapState> emit) async {
    if (state is MapLoadSuccess) {
      if (geometryEditor.isStarted) {
        // If geometry editor is active (drawing or editing), it automatically handles the tap
      } else {
        final identifyGraphicsOverlayResult = await mapViewController.identifyGraphicsOverlay(
            _graphicsOverlay,
            screenPoint: Offset(event.point.dx, event.point.dy),
            tolerance: 10, // tolerance
            returnPopupsOnly: false, // returnPopupsOnly
        );

        if (identifyGraphicsOverlayResult.graphics.isNotEmpty) {
            add(GraphicTapped(identifyGraphicsOverlayResult.graphics.first));
        }
      }
    }
  }

  Future<void> _onGraphicTapped(GraphicTapped event, Emitter<MapState> emit) async {
    if (state is MapLoadSuccess) {
      if (geometryEditor.isStarted) {
        geometryEditor.stop();
      }
      _originalGraphicBeingEdited = event.graphic; // Store the original graphic
      _graphicsOverlay.graphics.clear(); // Clear existing graphics
      geometryEditor.startWithGeometry(event.graphic.geometry!);
      _graphicsOverlay.graphics.add(event.graphic); // Add the graphic back for editing visualization
      emit((state as MapLoadSuccess).copyWith(isEditing: true));
    }
  }

  void _onUndoGeometryEditor(UndoGeometryEditor event, Emitter<MapState> emit) {
    if (geometryEditor.canUndo) {
      geometryEditor.undo();
    }
  }

  void _onRedoGeometryEditor(RedoGeometryEditor event, Emitter<MapState> emit) {
    if (geometryEditor.canRedo) {
      geometryEditor.redo();
    }
  }

  @override
  Future<void> close() {
    mapViewController.dispose();
    return super.close();
  }
}