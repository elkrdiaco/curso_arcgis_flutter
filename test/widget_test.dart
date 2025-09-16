import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Puedes importar widgets de tu aplicación para probarlos individualmente.
// import 'package:curso_arcgis_flutter/presentation/widgets/my_custom_button.dart';

void main() {
  // Un grupo de Tests Unitarios
  // Los tests unitarios no renderizan ninguna UI. Sirven para probar lógica pura de Dart,
  // como funciones, clases o BLoCs.
  group('Simple Math Unit Tests', () {
    test('La suma funciona', () {
      expect(1 + 1, 2);
    });
    
    test('La resta funciona', () {
      expect(5 - 3, 2);
    });
  });

  // Un grupo de Tests de Widgets
  // Los tests de widgets sirven para probar widgets individuales o pantallas de forma aislada.
  group('Simple Widget Tests', () {
    testWidgets('Encuentra un widget de Texto', (WidgetTester tester) async {
      // Define un widget simple para probar.
      const testWidget = MaterialApp(
        home: Scaffold(
          body: Text('Hola, Mundo!'),
        ),
      );

      // Construye el widget.
      await tester.pumpWidget(testWidget);

      // Verifica que el widget de Texto está en pantalla.
      expect(find.text('Hola, Mundo!'), findsOneWidget);
    });

    testWidgets('Encuentra un widget de Icono', (WidgetTester tester) async {
      // Define otro widget simple para probar.
      const testWidget = MaterialApp(
        home: Scaffold(body: Icon(Icons.add)),
      );
      await tester.pumpWidget(testWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}