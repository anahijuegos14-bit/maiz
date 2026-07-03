import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';

import '_shared/services/firebase_initializer.dart';
import 'app/app.dart';
import 'app/app_coordinator.dart';
import 'features/auth/manager/auth_manager.dart';
import 'locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.init();
  configureDependencies();
  await getIt.isReady<AuthManager>();
  Command.globalExceptionHandler = AppCoordinator.globalErrorHandler;
  runApp(const PlantManagerApp());
}

