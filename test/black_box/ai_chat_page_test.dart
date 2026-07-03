/*import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app/features/ai/pages/ai_chat_page.dart';
import 'package:mi_app/features/plants/manager/plants_manager.dart';
import 'package:mi_app/features/plants/model/plant_dto.dart';
import 'package:mi_app/features/plants/model/plant_status.dart';
import 'package:mi_app/locator.dart';

import '../helpers/in_memory_plants_data_source.dart';
import '../helpers/test_app.dart';

void main() {
  group('AIChatPage (caja negra)', () {
    late InMemoryPlantsDataSource dataSource;

    setUp(() async {
      await resetTestLocator();
      dataSource = InMemoryPlantsDataSource();
      await registerAuthForUi();
      registerPlantsSession(dataSource: dataSource);
      getIt<PlantsManager>().plants.value = [
        PlantEntry(
          id: 'p1',
          dto: PlantDto(
            name: 'Maíz Parcela 1',
            variety: 'Amarillo H-512',
            location: 'Vereda San Pedro',
            notes: '',
            status: PlantStatus.saludable,
            plantedDate: DateTime(2026, 5, 1),
            lastWateringDate: DateTime(2026, 6, 1),
            wateringHistory: const [],
          ),
        ),
      ];
    });

    tearDown(() async {
      dataSource.dispose();
      await resetTestLocator();
    });

    testWidgets('muestra selector, saludo y preguntas rapidas', (tester) async {
      await pumpTestApp(tester, home: const AIChatPage(), withAuth: false);
      await tester.pumpAndSettle();

      expect(find.text('Chat con IA'), findsOneWidget);
      expect(find.text('Planta a consultar'), findsOneWidget);
      expect(find.text('Sin planta específica'), findsOneWidget);
      expect(find.text('¿Cómo está mi planta?'), findsOneWidget);
      expect(find.text('Enviar'), findsOneWidget);
    });

    testWidgets('envia una pregunta y muestra respuesta del asistente',
        (tester) async {
      await pumpTestApp(tester, home: const AIChatPage(), withAuth: false);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(EditableText).last,
        'Plagas comunes en maíz',
      );
      await tester.tap(find.text('Enviar'));
      await tester.pumpAndSettle();

      expect(find.text('Plagas comunes en maíz'), findsWidgets);
      expect(find.textContaining('Gusano cogollero'), findsOneWidget);
    });
  });
}*/
