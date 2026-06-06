import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app/_shared/services/interaction_manager.dart';
import 'package:mi_app/features/ai/manager/ai_chat_manager.dart';
import 'package:mi_app/features/ai/services/ai_chat_service.dart';
import 'package:mi_app/features/analysis/manager/analysis_manager.dart';
import 'package:mi_app/features/analysis/services/analysis_data_source.dart';
import 'package:mi_app/features/auth/manager/auth_manager.dart';
import 'package:mi_app/features/auth/model/app_user.dart';
import 'package:mi_app/features/auth/services/firebase_auth_service.dart';
import 'package:mi_app/features/camera/manager/camera_manager.dart';
import 'package:mi_app/features/camera/services/camera_service.dart';
import 'package:mi_app/features/plants/manager/plants_manager.dart';
import 'package:mi_app/features/plants/services/plants_data_source.dart';
import 'package:mi_app/_shared/theme/app_theme.dart';
import 'package:mi_app/locator.dart';

import 'in_memory_analysis_data_source.dart';
import 'in_memory_plants_data_source.dart';

Future<void> resetTestLocator() async {
  if (getIt.isRegistered<AuthManager>()) {
    getIt<AuthManager>().dispose();
  }
  await getIt.reset();
}

Future<void> registerAuthForUi({bool signedIn = false}) async {
  if (!getIt.isRegistered<InteractionManager>()) {
    getIt.registerSingleton<InteractionManager>(InteractionManager());
  }
  if (!getIt.isRegistered<FirebaseAuthService>()) {
    getIt.registerSingleton<FirebaseAuthService>(
      FirebaseAuthService(MockFirebaseAuth(signedIn: signedIn)),
    );
  }
  if (!getIt.isRegistered<AiChatService>()) {
    getIt.registerSingleton<AiChatService>(AiChatService());
  }
  if (!getIt.isRegistered<CameraService>()) {
    getIt.registerSingleton<CameraService>(CameraService());
  }
  if (!getIt.isRegistered<AuthManager>()) {
    final authManager = AuthManager(authService: getIt<FirebaseAuthService>());
    getIt.registerSingleton<AuthManager>(authManager);
    await authManager.init();
  }
}

void registerPlantsSession({
  required InMemoryPlantsDataSource dataSource,
  InMemoryAnalysisDataSource? analysisDataSource,
  AppUser user = const AppUser(
    id: 'test-user',
    email: 'u@test.com',
    name: 'Tester',
  ),
}) {
  if (!getIt.isRegistered<AiChatService>()) {
    getIt.registerSingleton<AiChatService>(AiChatService());
  }
  if (!getIt.isRegistered<CameraService>()) {
    getIt.registerSingleton<CameraService>(CameraService());
  }

  final analysisSource = analysisDataSource ?? InMemoryAnalysisDataSource();
  final plantsManager = PlantsManager(user: user, service: dataSource);
  final analysisManager = AnalysisManager(
    userId: user.id,
    service: analysisSource,
    plantsManager: plantsManager,
  );

  if (!getIt.isRegistered<AppUser>()) {
    getIt.registerSingleton<AppUser>(user);
  }
  if (!getIt.isRegistered<PlantsDataSource>()) {
    getIt.registerSingleton<PlantsDataSource>(dataSource);
  }
  if (!getIt.isRegistered<AnalysisDataSource>()) {
    getIt.registerSingleton<AnalysisDataSource>(analysisSource);
  }
  if (!getIt.isRegistered<PlantsManager>()) {
    getIt.registerSingleton<PlantsManager>(plantsManager);
  }
  if (!getIt.isRegistered<AnalysisManager>()) {
    getIt.registerSingleton<AnalysisManager>(analysisManager);
  }
  if (!getIt.isRegistered<CameraManager>()) {
    getIt.registerSingleton<CameraManager>(
      CameraManager(
        cameraService: getIt<CameraService>(),
        plantsManager: plantsManager,
        analysisManager: analysisManager,
      ),
    );
  }
  if (!getIt.isRegistered<AiChatManager>()) {
    getIt.registerSingleton<AiChatManager>(
      AiChatManager(
        chatService: getIt<AiChatService>(),
        plantsManager: plantsManager,
        analysisManager: analysisManager,
      ),
    );
  }
}

Future<void> pumpTestApp(
  WidgetTester tester, {
  required Widget home,
  bool withAuth = true,
}) async {
  if (withAuth) {
    await registerAuthForUi();
  } else if (!getIt.isRegistered<InteractionManager>()) {
    getIt.registerSingleton<InteractionManager>(InteractionManager());
  }

  tester.view.physicalSize = const Size(480, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: SizedBox(
        width: 480,
        height: 900,
        child: home,
      ),
    ),
  );
  await tester.pump();
}
