import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app/features/plants/pages/plant_form_page.dart';

import '../helpers/in_memory_plants_data_source.dart';
import '../helpers/test_app.dart';

void main() {
  group('PlantFormPage (caja negra)', () {
    late InMemoryPlantsDataSource dataSource;

    setUp(() async {
      await resetTestLocator();
      dataSource = InMemoryPlantsDataSource();
      await registerAuthForUi();
      registerPlantsSession(dataSource: dataSource);
    });

    tearDown(() async {
      dataSource.dispose();
      await resetTestLocator();
    });

    testWidgets('muestra titulo y campos para nueva planta', (tester) async {
      await pumpTestApp(tester, home: const PlantFormPage(), withAuth: false);
      await tester.pumpAndSettle();

      expect(find.text('Registrar Planta'), findsWidgets);
      expect(find.text('Nombre *'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Registrar Planta'), findsOneWidget);
    });

    testWidgets('exige nombre antes de guardar', (tester) async {
      await pumpTestApp(tester, home: const PlantFormPage(), withAuth: false);
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.widgetWithText(ElevatedButton, 'Registrar Planta'),
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Registrar Planta'));
      await tester.pump();

      expect(find.text('El nombre es obligatorio.'), findsOneWidget);
    });
  });
}
