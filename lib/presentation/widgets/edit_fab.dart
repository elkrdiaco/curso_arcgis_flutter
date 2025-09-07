import 'package:curso_arcgis_flutter/presentation/bloc/map/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditFab extends StatelessWidget {
  const EditFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      heroTag: 'edit_polygon',
      elevation: 2,
      onPressed: () => context.read<MapBloc>().add(StartPolygonEditing()),
      child: const Icon(Icons.edit_outlined),
    );
  }
}