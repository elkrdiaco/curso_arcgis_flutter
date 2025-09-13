// lib/bloc/map_bloc.dart
import 'dart:async';

import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:bloc/bloc.dart';
import 'package:curso_arcgis_flutter/data/repositories/map/map_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'map_event.dart';
part 'map_state.dart';

 // --- Símbolos ---
  // Estos símbolos ahora están dentro del BLoC para un mejor encapsulamiento.

  final _polygonSymbol = SimpleFillSymbol(
    style: SimpleFillSymbolStyle.solid,
    color: Colors.red.withAlpha(127),
    outline: SimpleLineSymbol(
      style: SimpleLineSymbolStyle.solid,
      color: Colors.red,
      width: 2,
    ),
  );

  final _polylineSymbol = SimpleLineSymbol(
    style: SimpleLineSymbolStyle.solid,
    color: Colors.blue.shade800,
    width: 2,
  );

  final _pointSymbol = SimpleMarkerSymbol(
    style: SimpleMarkerSymbolStyle.circle,
    color: Colors.black,
    size: 12,
  );

  final _editorFillPolygon = SimpleFillSymbol(
    style: SimpleFillSymbolStyle.solid,
    color: Colors.red.shade200.withAlpha(130),
    outline: SimpleLineSymbol(
      style: SimpleLineSymbolStyle.solid,
      color: Colors.red.shade700,
      width: 2,
    ),
  );

  final _editorLine = SimpleLineSymbol(
    style: SimpleLineSymbolStyle.solid,
    color: Colors.blue.shade700,
    width: 2,
  );

    // --- Fin de Símbolos ---

class MapBloc extends Bloc<MapEvent, MapState> {
  ArcGISMapViewController mapViewController;
  GeometryEditor geometryEditor;
  final _polygonGraphicsOverlay = GraphicsOverlay();
  final _polylineGraphicsOverlay = GraphicsOverlay();
  final _pointGraphicsOverlay = GraphicsOverlay();
  final MapRepository mapRepository;
  Graphic? _originalGraphicBeingEdited; // To store the graphic being edited

  MapBloc({
    required this.mapViewController, 
    required this.geometryEditor,
    required this.mapRepository,
  }) : super(MapInitial()) {
    on<MapInitialized>(_onMapInitialized);
    on<UpdateBasemapStyle>(_onUpdateBasemapStyle);
    on<GpsToggled>(_onGpsToggled);

    on<StartPolygonEditing>(_onStartPolygonEditing);
    on<StartPolylineEditing>(_onStartPolylineEditing);
    on<StartPointEditing>(_onStartPointEditing);
    on<SavePolygon>(_onSavePolygon);
    on<CancelEditing>(_onCancelEditing);
    on<MapTapped>(_onMapTapped);
    on<GraphicTapped>(_onGraphicTapped);
    on<UndoGeometryEditor>(_onUndoGeometryEditor);
    on<RedoGeometryEditor>(_onRedoGeometryEditor);
    on<ToggleLayersList>(_onToggleLayersList);
    on<ToggleLayerVisibility>(_onToggleLayerVisibility);
    on<ToggleSelectionMode>(_onToggleSelectionMode);
  }

  // Maneja el evento de inicialización del mapa.
  Future<void> _onMapInitialized(
    MapInitialized event,
    Emitter<MapState> emit,
  ) async {
    final basemapStyle = event.brightness == Brightness.dark
        ? BasemapStyle.arcGISNavigationNight // Un buen mapa base oscuro
        : BasemapStyle.openStreets; // El mapa base claro actual

    final map = ArcGISMap.withBasemapStyle(basemapStyle);

    final pobladosLayer = mapRepository.getPobladosLayer();
    map.operationalLayers.add(pobladosLayer);
    mapViewController.locationDisplay.dataSource = SystemLocationDataSource();
    mapViewController.arcGISMap = map;
    mapViewController.setViewpoint(
      Viewpoint.withLatLongScale(
        latitude: 34.02700,
        longitude: -118.80500,
        scale: 72000,
      ),
    );

    mapViewController.geometryEditor ??= geometryEditor;

    // Clear existing graphics overlays before adding the one managed by the BLoC
    mapViewController.graphicsOverlays.clear();
    mapViewController.graphicsOverlays.addAll([
      _polygonGraphicsOverlay,
      _polylineGraphicsOverlay,
      _pointGraphicsOverlay,
    ]);

    final allLayers = [
      LayerInfo(name: 'Poblados', layerObject: pobladosLayer),
      LayerInfo(name: 'Polígonos', layerObject: _polygonGraphicsOverlay),
      LayerInfo(name: 'Polilíneas', layerObject: _polylineGraphicsOverlay),
      LayerInfo(name: 'Puntos', layerObject: _pointGraphicsOverlay),
    ];

    // Emite el estado de éxito una vez que el mapa está configurado.
    emit(MapLoadSuccess(isGpsEnabled: false, layers: allLayers));
  }

  // Maneja el evento para activar/desactivar el GPS.
  void _onGpsToggled(
    GpsToggled event,
    Emitter<MapState> emit,
  ) {
    if (state is MapLoadSuccess) {
      final currentState = state as MapLoadSuccess;
      final locationDisplay = mapViewController.locationDisplay;

      if (locationDisplay.autoPanMode == LocationDisplayAutoPanMode.off) {
        locationDisplay.autoPanMode = LocationDisplayAutoPanMode.recenter;
        locationDisplay.start();
        emit(currentState.copyWith(isGpsEnabled: true));
      } else {
        locationDisplay.autoPanMode = LocationDisplayAutoPanMode.off;
        locationDisplay.stop();
        emit(currentState.copyWith(isGpsEnabled: false));
      }
    }
  }

  void _onStartPolygonEditing(StartPolygonEditing event, Emitter<MapState> emit) {
    if (state is MapLoadSuccess) {
      if (geometryEditor.isStarted) {
        return; // Already editing, do nothing
      }
      geometryEditor.tool.style.lineSymbol = _editorFillPolygon.outline;
      geometryEditor.tool.style.fillSymbol = _editorFillPolygon;
      geometryEditor.startWithGeometryType(GeometryType.polygon);
      emit((state as MapLoadSuccess).copyWith(isEditing: true));
    }
  }

  void _onStartPolylineEditing(StartPolylineEditing event, Emitter<MapState> emit) {
    if (state is MapLoadSuccess) {
      if (geometryEditor.isStarted) {
        return; // Already editing, do nothing
      }
      geometryEditor.tool.style.lineSymbol = _editorLine;
      // No fill symbol for polylines
      geometryEditor.startWithGeometryType(GeometryType.polyline);
      emit((state as MapLoadSuccess).copyWith(isEditing: true));
    }
  }

  void _onStartPointEditing(StartPointEditing event, Emitter<MapState> emit) {
    if (state is MapLoadSuccess) {
      if (geometryEditor.isStarted) {
        return; // Already editing, do nothing
      }
      geometryEditor.startWithGeometryType(GeometryType.point);
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
      final Graphic graphic;
      switch (geometry.geometryType) {
        case GeometryType.polygon:
          graphic = Graphic(geometry: geometry, symbol: _polygonSymbol);
          _polygonGraphicsOverlay.graphics.add(graphic);
          break;
        case GeometryType.polyline:
          graphic = Graphic(geometry: geometry, symbol: _polylineSymbol);
          _polylineGraphicsOverlay.graphics.add(graphic);
          break;
        case GeometryType.point:
          graphic = Graphic(geometry: geometry, symbol: _pointSymbol);
          _pointGraphicsOverlay.graphics.add(graphic);
          break;
        default:
          geometryEditor.stop();
          emit((state as MapLoadSuccess).copyWith(isEditing: false));
          return;
      }
      _originalGraphicBeingEdited = null; // Clear the reference after saving
      geometryEditor.stop();
      emit((state as MapLoadSuccess).copyWith(isEditing: false));
    }
  }

  void _onCancelEditing(CancelEditing event, Emitter<MapState> emit) {
    if (state is MapLoadSuccess) {
      geometryEditor.stop();

      if (_originalGraphicBeingEdited != null) {
        // If we were editing an existing graphic, restore it to its correct layer
        final graphicToRestore = _originalGraphicBeingEdited!;
        switch (graphicToRestore.geometry!.geometryType) {
          case GeometryType.polygon:
            _polygonGraphicsOverlay.graphics.add(graphicToRestore);
            break;
          case GeometryType.polyline:
            _polylineGraphicsOverlay.graphics.add(graphicToRestore);
            break;
          case GeometryType.point:
            _pointGraphicsOverlay.graphics.add(graphicToRestore);
            break;
          default:
            break;
        }
        _originalGraphicBeingEdited = null; // Clear the reference
      }

      emit((state as MapLoadSuccess).copyWith(isEditing: false));
    }
  }

  Future<void> _onMapTapped(MapTapped event, Emitter<MapState> emit) async {
    if (state is MapLoadSuccess) {
      if (geometryEditor.isStarted) {
        // If geometry editor is active (drawing or editing), it automatically handles the tap
      } else if ((state as MapLoadSuccess).isSelectionModeActive) {
        // Identify on each layer separately since `identifyGraphicsOverlays` (plural) is not available in this version
        final polygonResults = await mapViewController.identifyGraphicsOverlay(
          _polygonGraphicsOverlay,
          screenPoint: event.point,
          tolerance: 10,
          returnPopupsOnly: false,
        );
        final polylineResults = await mapViewController.identifyGraphicsOverlay(
          _polylineGraphicsOverlay,
          screenPoint: event.point,
          tolerance: 10,
          returnPopupsOnly: false,
        );
        final pointResults = await mapViewController.identifyGraphicsOverlay(
          _pointGraphicsOverlay,
          screenPoint: event.point,
          tolerance: 10,
          returnPopupsOnly: false,
        );

        // Combine all found graphics into a single list
        final tappedGraphics = [
          ...polygonResults.graphics,
          ...polylineResults.graphics,
          ...pointResults.graphics,
        ];

        // If any graphic was found, trigger the GraphicTapped event with the first one.
        if (tappedGraphics.isNotEmpty) {
          add(GraphicTapped(tappedGraphics.first));
        }
      }
    }
  }

  Future<void> _onGraphicTapped(GraphicTapped event, Emitter<MapState> emit) async {
    if (state is MapLoadSuccess) {
      if (geometryEditor.isStarted) {
        geometryEditor.stop();
      }
      _originalGraphicBeingEdited = event.graphic; // Store the graphic to be edited

      // Remove the graphic from its correct layer
      switch (event.graphic.geometry!.geometryType) {
        case GeometryType.polygon:
          geometryEditor.tool.style.fillSymbol = _editorFillPolygon;
          geometryEditor.tool.style.lineSymbol = _editorFillPolygon.outline;
          _polygonGraphicsOverlay.graphics.remove(event.graphic);
          break;
        case GeometryType.polyline:
          geometryEditor.tool.style.lineSymbol = _editorLine;
          _polylineGraphicsOverlay.graphics.remove(event.graphic);
          break;
        case GeometryType.point:
          _pointGraphicsOverlay.graphics.remove(event.graphic);
          break;
        default:
          break;
      }
      geometryEditor.startWithGeometry(event.graphic.geometry!);
      emit((state as MapLoadSuccess).copyWith(isEditing: true, isSelectionModeActive: false));
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

  void _onToggleLayersList(ToggleLayersList event, Emitter<MapState> emit) {
    if (state is MapLoadSuccess) {
      final currentState = state as MapLoadSuccess;
      emit(currentState.copyWith(showLayersList: !currentState.showLayersList));
    }
  }

  void _onToggleLayerVisibility(
      ToggleLayerVisibility event, Emitter<MapState> emit) {
    if (state is MapLoadSuccess) {
      final currentState = state as MapLoadSuccess;
      final toggledLayerInfo = event.layer;
      final layerObject = toggledLayerInfo.layerObject;
      final newVisibility = !toggledLayerInfo.isVisible;

      if (layerObject is Layer) {
        layerObject.isVisible = newVisibility;
      } else if (layerObject is GraphicsOverlay) {
        layerObject.isVisible = newVisibility;
      }

      // 2. Creamos una nueva lista de LayerInfo, reemplazando el objeto antiguo por uno nuevo e inmutable.
      final updatedLayers = currentState.layers.map((layerInfo) {
        if (layerInfo == toggledLayerInfo) {
          // Usamos copyWith para crear una nueva instancia con la visibilidad actualizada
          return layerInfo.copyWith(isVisible: newVisibility);
        }
        return layerInfo;
      }).toList();

      emit(currentState.copyWith(layers: updatedLayers));
    }
  }

  void _onToggleSelectionMode(ToggleSelectionMode event, Emitter<MapState> emit) {
    if (state is MapLoadSuccess) {
      final currentState = state as MapLoadSuccess;
      emit(currentState.copyWith(
          isSelectionModeActive: !currentState.isSelectionModeActive));
    }
  }

  @override
  Future<void> close() {
    mapViewController.dispose();
    return super.close();
  }

  Future<void> _onUpdateBasemapStyle(
    UpdateBasemapStyle event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoadSuccess) {
      final basemapStyle = event.brightness == Brightness.dark
          ? BasemapStyle.arcGISNavigationNight
          : BasemapStyle.openStreets;

      final newMap = ArcGISMap.withBasemapStyle(basemapStyle);

      // Preservamos las capas operacionales existentes
      final currentMap = mapViewController.arcGISMap;
      if (currentMap != null) {
        newMap.operationalLayers.addAll(currentMap.operationalLayers);
      }
      mapViewController.arcGISMap = newMap;
    }
  }
}