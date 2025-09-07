import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:curso_arcgis_flutter/presentation/bloc/map/map_bloc.dart'; // Import your MapBloc
import 'package:curso_arcgis_flutter/config/context_extension.dart'; // Add this import

class EditingControls extends StatelessWidget {
  final bool isEditing;

  const EditingControls({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      curve: Curves.bounceOut,
      duration: const Duration(milliseconds: 300),
      bottom: isEditing ? 40 : -100, // Slide in/out from bottom
      left: 10,
      right: 10,
      child: Container(
        height: 90, // Fixed height for the container
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: context.colorApp.primary.withAlpha(230),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                elevation: 2,
                heroTag: 'save_polygon',
                onPressed: () => context.read<MapBloc>().add(SavePolygon()),
                child: Icon(Icons.save_rounded),
              ),
              FloatingActionButton(
                elevation: 2,
                heroTag: 'cancel_editing',
                onPressed: () => context.read<MapBloc>().add(CancelEditing()),
                child: Icon(Icons.delete_forever),
              ),
              FloatingActionButton(
                elevation: 2,
                heroTag: 'undo_editing',
                onPressed: () =>
                    context.read<MapBloc>().add(UndoGeometryEditor()),
                child: Icon(Icons.undo),
              ),
              FloatingActionButton(
                elevation: 2,
                heroTag: 'redo_editing',
                onPressed: () =>
                    context.read<MapBloc>().add(RedoGeometryEditor()),
                child: Icon(Icons.redo),
              ),
            ],
          ),
        ),
    );
  }
}
