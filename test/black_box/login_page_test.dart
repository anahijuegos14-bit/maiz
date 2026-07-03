/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app/app/routes.dart';
import 'package:mi_app/features/auth/pages/login_page.dart';
import 'package:mi_app/features/auth/pages/register_page.dart';

import '../helpers/test_app.dart';

void main() {
  group('LoginPage (caja negra)', () {
    setUp(() async {
      await resetTestLocator();
    });

    tearDown(() async {
      await resetTestLocator();
    });

    testWidgets('muestra marca, campos y accion principal', (tester) async {
      await pumpTestApp(tester, home: const LoginPage());
      await tester.pumpAndSettle();

      expect(find.text('Hola de nuevo'), findsOneWidget);
      expect(find.text('Correo electrónico'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Iniciar sesión'), findsOneWidget);
      expect(find.text('Regístrate'), findsOneWidget);
    });

    testWidgets('navega a registro al pulsar registrate', (tester) async {
      await pumpTestApp(
        tester,
        home: Navigator(
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRoutes.register:
                return MaterialPageRoute<void>(
                  settings: settings,
                  builder: (_) => const RegisterPage(),
                );
              default:
                return MaterialPageRoute<void>(
                  settings: settings,
                  builder: (_) => const LoginPage(),
                );
            }
          },
        ),
      );

      await tester.tap(find.text('Regístrate'));
      await tester.pumpAndSettle();

      expect(find.text('Crear cuenta'), findsWidgets);
      expect(find.widgetWithText(ElevatedButton, 'Crear cuenta'), findsOneWidget);
    });
  });
}*/
