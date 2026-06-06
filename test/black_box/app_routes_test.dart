import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app/app/routes.dart';
import 'package:mi_app/features/analysis/pages/analysis_flow_page.dart';
import 'package:mi_app/features/auth/pages/landing_page.dart';
import 'package:mi_app/features/auth/pages/login_page.dart';
import 'package:mi_app/features/auth/pages/register_page.dart';
import 'package:mi_app/features/home/pages/home_page.dart';
import 'package:mi_app/features/plants/pages/plant_form_page.dart';

void main() {
  group('AppRoutes (caja negra)', () {
    test('expone rutas principales de la app', () {
      expect(AppRoutes.landing, '/');
      expect(AppRoutes.login, '/login');
      expect(AppRoutes.register, '/register');
      expect(AppRoutes.home, '/home');
      expect(AppRoutes.plantForm, '/plant-form');
      expect(AppRoutes.analysis, '/analysis');
    });

    testWidgets('builders devuelven pantallas esperadas', (tester) async {
      late BuildContext context;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              context = ctx;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      final routes = AppRoutes.routes;

      expect(routes[AppRoutes.landing]!(context), isA<LandingPage>());
      expect(routes[AppRoutes.login]!(context), isA<LoginPage>());
      expect(routes[AppRoutes.register]!(context), isA<RegisterPage>());
      expect(routes[AppRoutes.home]!(context), isA<HomePage>());
      expect(routes[AppRoutes.plantForm]!(context), isA<PlantFormPage>());
      expect(routes[AppRoutes.analysis]!(context), isA<AnalysisFlowPage>());
    });
  });
}
