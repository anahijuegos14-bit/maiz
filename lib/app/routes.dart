import 'package:flutter/widgets.dart';

import '../features/analysis/pages/analysis_flow_page.dart';
import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/register_page.dart';
import '../features/home/pages/home_page.dart';
import '../features/plants/pages/plant_form_page.dart';

class AppRoutes {
  static const String landing = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String plantForm = '/plant-form';
  static const String analysis = '/analysis';

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginPage(),
        register: (_) => const RegisterPage(),
        home: (_) => const HomePage(),
        plantForm: (_) => const PlantFormPage(),
        analysis: (_) => const AnalysisFlowPage(),
      };
}