import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app/features/analysis/manager/analysis_manager.dart';
import 'package:mi_app/features/analysis/model/analysis_dto.dart';
import 'package:mi_app/features/history/pages/history_page.dart';
import 'package:mi_app/locator.dart';

import '../helpers/in_memory_analysis_data_source.dart';
import '../helpers/in_memory_plants_data_source.dart';
import '../helpers/test_app.dart';

void main() {
  group('HistoryPage (caja negra)', () {
    late InMemoryPlantsDataSource plantsDataSource;
    late InMemoryAnalysisDataSource analysisDataSource;

    setUp(() async {
      await resetTestLocator();
      plantsDataSource = InMemoryPlantsDataSource();
      analysisDataSource = InMemoryAnalysisDataSource();
      await registerAuthForUi();
      registerPlantsSession(
        dataSource: plantsDataSource,
        analysisDataSource: analysisDataSource,
      );
      getIt<AnalysisManager>().analyses.value = [
        AnalysisEntry(
          id: 'a1',
          dto: AnalysisDto(
            plantId: 'p1',
            plantName: 'Maíz Parcela 1',
            type: AnalysisType.hoja,
            imageName: 'hoja.jpg',
            result: 'Enfermedad detectada',
            disease: 'Roya común',
            affectionPercent: 40,
            date: DateTime(2026, 6, 1),
            recommendations: const ['Aplicar fungicida foliar.'],
          ),
        ),
      ];
    });

    tearDown(() async {
      plantsDataSource.dispose();
      analysisDataSource.dispose();
      await resetTestLocator();
    });

    testWidgets('muestra analisis y boton de recomendaciones', (tester) async {
      await pumpTestApp(tester, home: const HistoryPage(), withAuth: false);
      await tester.pumpAndSettle();

      expect(find.text('Todos'), findsOneWidget);
      expect(find.text('Hoja'), findsOneWidget);
      expect(find.text('Terreno'), findsOneWidget);
      expect(find.text('Maíz Parcela 1'), findsOneWidget);
      expect(find.text('Ver recomendaciones'), findsOneWidget);
    });

    testWidgets('abre recomendaciones del analisis', (tester) async {
      await pumpTestApp(tester, home: const HistoryPage(), withAuth: false);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ver recomendaciones'));
      await tester.pumpAndSettle();

      expect(find.text('Recomendaciones'), findsOneWidget);
      expect(find.textContaining('Aplicar fungicida'), findsOneWidget);
    });
  });
}
