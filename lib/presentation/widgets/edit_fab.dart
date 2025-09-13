import 'package:curso_arcgis_flutter/presentation/bloc/map/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditFab extends StatelessWidget {
  const EditFab({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        FloatingActionButton(
          mini: true,
          heroTag: 'edit_polygon',
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Added shape
          onPressed: () => context.read<MapBloc>().add(StartPolygonEditing()),
          child: Icon(Icons.pentagon_outlined),
        ),
        FloatingActionButton(
          mini: true,
          heroTag: 'edit_polyline',
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Added shape
          onPressed: () => context.read<MapBloc>().add(StartPolylineEditing()),
          child: Icon(Icons.polyline_outlined),
        ),
        FloatingActionButton(
          mini: true,
          heroTag: 'edit_point',
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Added shape
          onPressed: () => context.read<MapBloc>().add(StartPointEditing()),
          child: Icon(Icons.circle_outlined),
        ),
      ],
    );
  }
}