import 'package:curso_arcgis_flutter/config/context_extension.dart';
import 'package:curso_arcgis_flutter/presentation/bloc/map/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MapAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        final isEditing = state is MapLoadSuccess && state.isEditing;

        if (isEditing) {
          return _buildEditingAppBar(context);
        } else {
          return _buildDefaultAppBar(context);
        }
      },
    );
  }

  AppBar _buildDefaultAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'ArcGIS Maps SDK for Flutter',
        style: TextStyle(fontSize: 16, color: context.colorApp.colorScheme.onPrimary),
      ),
      centerTitle: false,
      backgroundColor: context.colorApp.colorScheme.primary,
      elevation: 2,
      shadowColor: context.colorApp.colorScheme.shadow,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          color: context.colorApp.colorScheme.onPrimary,
          onPressed: () {
            context.read<MapBloc>().add(MapInitialized(context.colorApp.brightness));
          },
        ),
      ],
      leading: IconButton(
        tooltip: 'Capas',
        icon: SvgPicture.asset(
          'assets/images/ic_layers.svg',
          colorFilter: ColorFilter.mode(
            context.colorApp.colorScheme.onPrimary,
            BlendMode.srcIn,
          ),
        ),
        onPressed: () {
          
        },
      ),
    );
  }

  AppBar _buildEditingAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Dibujando Polígono'),
      leading: IconButton(
        tooltip: 'Cancelar',
        icon: const Icon(Icons.close),
        onPressed: () => context.read<MapBloc>().add(CancelEditing()),
      ),
      actions: [
        IconButton(
          tooltip: 'Guardar Polígono',
          icon: const Icon(Icons.save_rounded),
          onPressed: () => context.read<MapBloc>().add(SavePolygon()),
        ),
      ],
      centerTitle: false,
      backgroundColor: context.colorApp.colorScheme.primary, // Added for consistency
      elevation: 2,
      shadowColor: context.colorApp.colorScheme.shadow, // Added for consistency
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}