/*import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app/features/diseases/pages/diseases_info_page.dart';

import '../helpers/test_app.dart';

void main() {
  group('DiseasesInfoPage (caja negra)', () {
    setUp(() async {
      await resetTestLocator();
    });

    tearDown(() async {
      await resetTestLocator();
    });

    testWidgets('muestra biblioteca y enfermedades principales', (tester) async {
      await pumpTestApp(
        tester,
        home: const DiseasesInfoPage(),
        withAuth: false,
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Biblioteca de enfermedades'), findsOneWidget);
      expect(find.textContaining('Roya'), findsWidgets);
      expect(find.textContaining('Mancha gris'), findsWidgets);
      expect(find.textContaining('Tiz'), findsWidgets);
      expect(find.text('Prevención'), findsWidgets);
    });

    testWidgets('expande una enfermedad y muestra sintomas y tratamiento',
        (tester) async {
      await pumpTestApp(
        tester,
        home: const DiseasesInfoPage(),
        withAuth: false,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('Roya').first);
      await tester.pumpAndSettle();

      expect(find.text('Síntomas'), findsOneWidget);
      expect(find.text('Tratamiento'), findsOneWidget);
      expect(find.text('Prevención'), findsWidgets);
    });
  });
}*/
