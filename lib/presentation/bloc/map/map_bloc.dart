// lib/bloc/map_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:arcgis_maps/arcgis_maps.dart' as arcgis;
import 'package:flutter/material.dart';

part 'map_bloc_event.dart';
part 'map_bloc_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  arcgis.ArcGISMapViewController mapViewController;
  arcgis.GeometryEditor geometryEditor;
  final _graphicsOverlay = arcgis.GraphicsOverlay();

  MapBloc(
      {required this.mapViewController, required this.geometryEditor})
      : super(MapInitial()) {
    on<MapInitialized>(_onMapInitialized);
    on<GpsToggled>(_onGpsToggled);
    on<ZoomIn>(_onZoomIn);
    on<ZoomOut>(_onZoomOut);

    on<StartPolygonEditing>(_onStartPolygonEditing);
    on<SavePolygon>(_onSavePolygon);
    on<CancelEditing>(_onCancelEditing);
  }

  // Maneja el evento de inicialización del mapa.
  Future<void> _onMapInitialized(
    MapInitialized event,
    Emitter<MapState> emit,
  ) async {
    final map = arcgis.ArcGISMap.withBasemapStyle(
      arcgis.BasemapStyle.openStreets,
    );
    final Uri uri = Uri.parse(
      'https://services5.arcgis.com/xZWz93fd6IlyKPjJ/arcgis/rest/services/Centros_Poblados_Margarita/FeatureServer/2',
    );

    map.operationalLayers.add(
      arcgis.FeatureLayer.withFeatureTable(
        arcgis.ServiceFeatureTable.withUri(uri),
      ),
    );

    mapViewController.locationDisplay.dataSource = arcgis.SystemLocationDataSource();
    mapViewController.arcGISMap = map;
    mapViewController.setViewpoint(
      arcgis.Viewpoint.withLatLongScale(
        latitude: 34.02700,
        longitude: -118.80500,
        scale: 72000,
      ),
    );

    mapViewController.geometryEditor = geometryEditor;
    mapViewController.graphicsOverlays.add(_graphicsOverlay);

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

  void _onZoomIn(
    ZoomIn event,
    Emitter<MapState> emit,
  ) {
    // La acción de zoom es un efecto secundario, no necesita cambiar el estado.
    final currentScale = mapViewController.scale;
    mapViewController.setViewpointScale(currentScale / 2);
    //no se hace emit porque no cambia el estado
  }

  void _onZoomOut(
    ZoomOut event,
    Emitter<MapState> emit,
  ) {
    // Corregimos la lógica para hacer zoom out.
    final currentScale = mapViewController.scale;
    mapViewController.setViewpointScale(currentScale * 2);
    //no se hace emit porque no cambia el estado
  }

  void _onStartPolygonEditing(
      StartPolygonEditing event, Emitter<MapState> emit) {
    if (state is MapLoadSuccess) {
      final currentState = state as MapLoadSuccess;
      geometryEditor.startWithGeometryType(arcgis.GeometryType.polygon);
      //Cambia el estado de isEditing ubicado en map_state
      emit(currentState.copyWith(isEditing: true));
    }
  }

  void _onSavePolygon(SavePolygon event, Emitter<MapState> emit) {
    if (state is MapLoadSuccess) {
      final currentState = state as MapLoadSuccess;
      final geometry = geometryEditor.geometry;
      if (geometry == null) {
        geometryEditor.stop();
        emit(currentState.copyWith(isEditing: false));
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

      final graphic = arcgis.Graphic(
        geometry: geometry,
        symbol: polygonSymbol,
      );

      _graphicsOverlay.graphics.add(graphic);
      geometryEditor.stop();
      emit(currentState.copyWith(isEditing: false));
    }
  }

  void _onCancelEditing(CancelEditing event, Emitter<MapState> emit) {
    if (state is MapLoadSuccess) {
      final currentState = state as MapLoadSuccess;
      geometryEditor.stop();
      emit(currentState.copyWith(isEditing: false));
    }
  }
}