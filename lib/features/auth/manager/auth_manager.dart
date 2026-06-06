import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/errors/exceptions.dart';
import '../../../_shared/services/interaction_manager.dart';
import '../../ai/manager/ai_chat_manager.dart';
import '../../ai/services/ai_chat_service.dart';
import '../../analysis/manager/analysis_manager.dart';
import '../../analysis/services/analysis_data_source.dart';
import '../../camera/manager/camera_manager.dart';
import '../../camera/services/camera_service.dart';
import '../../plants/manager/plants_manager.dart';
import '../../plants/services/plants_data_source.dart';
import '../model/app_user.dart';
import '../model/login_request.dart';
import '../model/register_request.dart';
import '../services/firebase_auth_service.dart';

class AuthManager {
  AuthManager({required FirebaseAuthService authService})
      : _authService = authService;

  final FirebaseAuthService _authService;

  final _userState = ValueNotifier<AppUser?>(null);
  ValueListenable<AppUser?> get userState => _userState;

  StreamSubscription<User?>? _authSubscription;

  late final loginCommand = Command.createAsync<LoginRequest, AppUser>(
    (request) => _authService.login(
      email: request.email.trim(),
      password: request.password.trim(),
    ),
    initialValue: AppUser.empty,
  );

  late final registerCommand = Command.createAsync<RegisterRequest, AppUser>(
    (request) => _authService.register(
      email: request.email.trim(),
      password: request.password.trim(),
      name: request.name.trim(),
    ),
    initialValue: AppUser.empty,
  );

  late final resetPasswordCommand = Command.createAsync<String, bool>(
    (email) async {
      await _authService.sendPasswordResetEmail(email);
      return true;
    },
    initialValue: false,
  );

  late final logoutCommand = Command.createAsyncNoParamNoResult(
    () => _authService.logout(),
  );

  Future<AuthManager> init() async {
    final interaction = di<InteractionManager>();
    loginCommand.errors.listen((error, _) {
      if (error == null) return;
      interaction.showSnackBar(_errorMessage(error), isError: true);
    });
    registerCommand.errors.listen((error, _) {
      if (error == null) return;
      interaction.showSnackBar(_errorMessage(error), isError: true);
    });
    resetPasswordCommand.errors.listen((error, _) {
      if (error == null) return;
      interaction.showSnackBar(_errorMessage(error), isError: true);
    });
    resetPasswordCommand.results.listen((result, _) {
      if (result.hasData && result.data == true) {
        interaction.showSnackBar(
          'Enlace de recuperación enviado. Revisa tu correo.',
        );
      }
    });

    _authSubscription = _authService.authStateChanges().listen((user) async {
      if (user == null) {
        await _clearUserSession();
        _userState.value = null;
        return;
      }
      await _ensureUserSession(_authService.mapUser(user));
    });

    final current = _authService.currentUser;
    if (current != null) {
      await _ensureUserSession(_authService.mapUser(current));
    }

    return this;
  }

  void dispose() {
    _authSubscription?.cancel();
    _userState.dispose();
  }

  Future<void> _ensureUserSession(AppUser user) async {
    if (di.isRegistered<AppUser>()) {
      final current = di<AppUser>();
      if (current.id == user.id) {
        _userState.value = user;
        return;
      }
      await di.popScope();
    }

    di.pushNewScope(
      scopeName: 'user-session',
      init: (scope) {
        scope.registerSingleton<AppUser>(user);

        scope.registerLazySingletonAsync<PlantsManager>(
          () => PlantsManager(
            user: user,
            service: di<PlantsDataSource>(),
          ).init(),
          dispose: (manager) => manager.dispose(),
        );

        scope.registerLazySingletonAsync<AnalysisManager>(
          () async {
            final plantsManager = await di.getAsync<PlantsManager>();

            return AnalysisManager(
              userId: user.id,
              service: di<AnalysisDataSource>(),
              plantsManager: plantsManager,
            ).init();
          },
          dispose: (manager) => manager.dispose(),
        );

        scope.registerLazySingleton<CameraManager>(
          () => CameraManager(
            cameraService: di<CameraService>(),
            plantsManager: di<PlantsManager>(),
            analysisManager: di<AnalysisManager>(),
          ),
        );

        scope.registerLazySingleton<AiChatManager>(
          () => AiChatManager(
            chatService: di<AiChatService>(),
            plantsManager: di<PlantsManager>(),
            analysisManager: di<AnalysisManager>(),
          ),
          dispose: (manager) => manager.dispose(),
        );
      },
    );

    await di.allReady();

    _userState.value = user;
  }

  Future<void> _clearUserSession() async {
    if (di.isRegistered<AppUser>()) {
      await di.popScope();
    }
    _userState.value = null;
  }

  String _errorMessage(CommandError error) {
    final underlying = error.error;
    if (underlying is ServerException) return underlying.message;
    return underlying.toString();
  }
}
