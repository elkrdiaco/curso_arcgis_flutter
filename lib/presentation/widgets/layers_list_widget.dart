import 'package:curso_arcgis_flutter/config/context_extension.dart';
import 'package:curso_arcgis_flutter/presentation/bloc/map/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayersListWidget extends StatelessWidget {
  final List<LayerInfo> layers;

  const LayersListWidget({super.key, required this.layers});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      right:60,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          // El color se manejará en los hijos para tener una cabecera de color diferente.
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias, // Importante para que los hijos respeten el borde redondeado
        child: SingleChildScrollView( // Usamos SingleChildScrollView para evitar overflows si hay muchas capas
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Cabecera ---
              Container(
                width: double.infinity,
                color: context.colorApp.floatingActionButtonTheme.backgroundColor,
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Capas del Mapa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.colorApp.floatingActionButtonTheme.foregroundColor,
                  ),
                ),
              ),
              // --- Cuerpo de la lista ---
              Container(
                color: context.colorApp.colorScheme.surface,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // El scroll lo maneja el SingleChildScrollView
                  itemCount: layers.length,
                  itemBuilder: (context, index) {
                    final layer = layers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(layer.name, style: TextStyle(color: context.colorApp.floatingActionButtonTheme.foregroundColor)),
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: layer.isVisible,
                              onChanged: (bool value) {
                                context
                                    .read<MapBloc>()
                                    .add(ToggleLayerVisibility(layer));
                              },
                              activeThumbColor: context.colorApp.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}