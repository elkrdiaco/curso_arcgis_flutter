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
    final colorApp = Theme.of(context).colorScheme;
    return AppBar(
      title: Text(
        'ArcGIS Maps SDK for Flutter',
        style: TextStyle(fontSize: 16, color: colorApp.onPrimary),
      ),
      centerTitle: false,
      backgroundColor: colorApp.primary,
      elevation: 2,
      shadowColor: colorApp.shadow,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          color: colorApp.onPrimary,
          onPressed: () {
            context.read<MapBloc>().add(MapInitialized());
          },
        ),
      ],
      leading: IconButton(
        tooltip: 'Capas',
        icon: SvgPicture.asset(
          'assets/images/ic_layers.svg',
          colorFilter: ColorFilter.mode(
            colorApp.onPrimary,
            BlendMode.srcIn,
          ),
        ),
        onPressed: () {},
      ),
    );
  }

  AppBar _buildEditingAppBar(BuildContext context) {
    final colorApp = Theme.of(context).colorScheme;
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
      backgroundColor: colorApp.primaryContainer,
      elevation: 2,
      shadowColor: colorApp.shadow,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}