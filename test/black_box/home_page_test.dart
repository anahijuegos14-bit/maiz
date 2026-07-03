import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app/features/home/pages/home_page.dart';

import '../helpers/in_memory_plants_data_source.dart';
import '../helpers/test_app.dart';

void main() {
  group('HomePage (caja negra)', () {
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

    testWidgets('inicia en dashboard con navegacion inferior', (tester) async {
      await pumpTestApp(tester, home: const HomePage(), withAuth: false);
      await tester.pumpAndSettle();

      expect(find.text('Resumen General'), findsOneWidget);
      expect(find.text('Acciones Rápidas'), findsOneWidget);
      expect(find.text('Inicio'), findsWidgets);
      expect(find.text('Mis Plantas'), findsWidgets);
      expect(find.text('Nuevo'), findsWidgets);
      expect(find.text('Historial'), findsWidgets);
      expect(find.text('Biblioteca'), findsWidgets);
    });

    testWidgets('muestra seccion mis plantas al seleccionar Mis Plantas',
        (tester) async {
      await pumpTestApp(tester, home: const HomePage(), withAuth: false);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mis Plantas').last);
      await tester.pumpAndSettle();

      expect(find.text('Mis Plantas'), findsWidgets);
      expect(find.text('Nueva Planta'), findsOneWidget);
    });
  });
}
