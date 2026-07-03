/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app/app/routes.dart';
import 'package:mi_app/features/auth/pages/login_page.dart';
import 'package:mi_app/features/auth/pages/register_page.dart';

import '../helpers/test_app.dart';

void main() {
  group('RegisterPage (caja negra)', () {
    setUp(() async {
      await resetTestLocator();
    });

    tearDown(() async {
      await resetTestLocator();
    });

    testWidgets('muestra formulario completo de registro', (tester) async {
      await pumpTestApp(tester, home: const RegisterPage());

      expect(find.text('Crear cuenta'), findsWidgets);
      expect(find.text('Nombre completo'), findsOneWidget);
      expect(find.text('Correo electrónico'), findsOneWidget);
      expect(find.text('Contraseña (mínimo 6 caracteres)'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Crear cuenta'), findsOneWidget);
    });

    testWidgets('vuelve al login con ya tengo cuenta', (tester) async {
      await pumpTestApp(
        tester,
        home: Navigator(
          onGenerateRoute: (settings) {
            if (settings.name == AppRoutes.register) {
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (_) => const RegisterPage(),
              );
            }
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => const LoginPage(),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Regístrate'));
      await tester.pumpAndSettle();
      expect(find.text('Crear cuenta'), findsWidgets);

      await tester.tap(find.text('Inicia sesión'));
      await tester.pumpAndSettle();

      expect(find.text('Hola de nuevo'), findsOneWidget);
    });
  });
}*/
