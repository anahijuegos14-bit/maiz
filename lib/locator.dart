import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '_shared/services/interaction_manager.dart';
import 'features/ai/services/ai_chat_service.dart';
import 'features/analysis/services/analysis_data_source.dart';
import 'features/analysis/services/analysis_firestore_service.dart';
import 'features/auth/manager/auth_manager.dart';
import 'features/auth/services/firebase_auth_service.dart';
import 'features/camera/services/camera_service.dart';
import 'features/plants/services/plants_data_source.dart';
import 'features/plants/services/plants_firestore_service.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerSingleton<InteractionManager>(InteractionManager());
  getIt.registerLazySingleton<FirebaseAuthService>(
    () => FirebaseAuthService(FirebaseAuth.instance),
  );
  getIt.registerLazySingleton<PlantsFirestoreService>(
    () => PlantsFirestoreService(FirebaseFirestore.instance),
  );
  getIt.registerLazySingleton<PlantsDataSource>(
    () => getIt<PlantsFirestoreService>(),
  );
  getIt.registerLazySingleton<AnalysisFirestoreService>(
    () => AnalysisFirestoreService(FirebaseFirestore.instance),
  );
  getIt.registerLazySingleton<AnalysisDataSource>(
    () => getIt<AnalysisFirestoreService>(),
  );
  getIt.registerLazySingleton<CameraService>(() => CameraService());
  getIt.registerLazySingleton<AiChatService>(() => AiChatService());
  getIt.registerLazySingletonAsync<AuthManager>(
    () => AuthManager(authService: getIt<FirebaseAuthService>()).init(),
    dispose: (manager) => manager.dispose(),
  );
}
