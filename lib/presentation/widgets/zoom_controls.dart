import 'package:curso_arcgis_flutter/presentation/bloc/map/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ZoomControls extends StatelessWidget {
  const ZoomControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          mini: true,
          heroTag: 'zoom_in',
          elevation: 1,
          onPressed: () {
            context.read<MapBloc>().add(ZoomIn());
          },
          child: const Icon(Icons.add),
        ),
        FloatingActionButton(
          mini: true,
          heroTag: 'zoom_out',
          elevation: 1,
          onPressed: () {
            context.read<MapBloc>().add(ZoomOut());
          },
          child: const Icon(Icons.remove),
        ),
      ],
    );
  }
}