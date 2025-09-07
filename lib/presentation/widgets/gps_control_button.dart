import 'package:curso_arcgis_flutter/presentation/bloc/map/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GpsControlButton extends StatelessWidget {
  final bool isGpsEnabled;
  const GpsControlButton({super.key, required this.isGpsEnabled});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      heroTag: 'my_location',
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Added shape
      onPressed: () => context.read<MapBloc>().add(GpsToggled()),
      child: Icon(
        isGpsEnabled
            ? Icons.location_disabled_rounded
            : Icons.my_location_rounded,
      ),
    );
  }
}