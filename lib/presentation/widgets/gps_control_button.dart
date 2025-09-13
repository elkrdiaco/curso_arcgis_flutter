import 'package:curso_arcgis_flutter/config/context_extension.dart';
import 'package:curso_arcgis_flutter/presentation/bloc/map/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class GpsControlButton extends StatelessWidget {
  final bool isGpsEnabled;
  final bool showLayersList;
  final bool isSelectionModeActive;
  const GpsControlButton({
    super.key, 
    required this.isGpsEnabled, 
    required this.showLayersList, 
    required this.isSelectionModeActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
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
        ),
        FloatingActionButton(
          mini: true,
          heroTag: 'layers',
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), 
          backgroundColor: showLayersList ? context.colorApp.colorScheme.primary : null,
          onPressed: () { 
            context.read<MapBloc>().add(ToggleLayersList());
          },
          child: 
          (showLayersList) 
          ? Icon(
            Icons.keyboard_double_arrow_left_rounded,
            color: context.colorApp.colorScheme.onPrimary,
          )
          : SvgPicture.asset('assets/images/ic_layers.svg',
            colorFilter: ColorFilter.mode(
              showLayersList 
              ? context.colorApp.colorScheme.onPrimary 
              : context.colorApp.floatingActionButtonTheme.foregroundColor!,
              BlendMode.srcIn,
            ),
          ),
        ),
        FloatingActionButton(
          mini: true,
          heroTag: 'select_geometry',
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Added shape
          backgroundColor: isSelectionModeActive ? context.colorApp.colorScheme.primary : null,
          onPressed: (){
            context.read<MapBloc>().add(ToggleSelectionMode());
          },
          child: Icon(
            Icons.touch_app_rounded,
            color: isSelectionModeActive ? context.colorApp.colorScheme.onPrimary : null,
          ),
        ),
      ],
    );
  }
}