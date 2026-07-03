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
  Future<void>? _pendingSessionFuture;
  String? _pendingSessionUserId;

  late final loginCommand = Command.createAsync<LoginRequest, AppUser>(
    (request) async {
      final user = await _authService.login(
        email: request.email.trim(),
        password: request.password.trim(),
      );
      await _ensureUserSession(user);
      return user;
    },
    initialValue: AppUser.empty,
  );

  late final registerCommand = Command.createAsync<RegisterRequest, AppUser>(
    (request) async {
      final user = await _authService.register(
        email: request.email.trim(),
        password: request.password.trim(),
        name: request.name.trim(),
      );
      await _ensureUserSession(user);
      return user;
    },
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

  Future<void> _ensureUserSession(AppUser user) {
    if (_pendingSessionUserId == user.id && _pendingSessionFuture != null) {
      return _pendingSessionFuture!;
    }

    _pendingSessionUserId = user.id;
    _pendingSessionFuture = _doEnsureUserSession(user).whenComplete(() {
      if (_pendingSessionUserId == user.id) {
        _pendingSessionUserId = null;
        _pendingSessionFuture = null;
      }
    });
    return _pendingSessionFuture!;
  }

  Future<void> _doEnsureUserSession(AppUser user) async {
    if (di.isRegistered<AppUser>()) {
      final current = di<AppUser>();
      if (current.id == user.id) {
        _userState.value = user;
        return;
      }
      await di.popScope();
    }

    di.pushNewScope(scopeName: 'user-session');

    di.registerSingleton<AppUser>(user);

    final plantsManager = await PlantsManager(
      user: user,
      service: di<PlantsDataSource>(),
    ).init();
    di.registerSingleton<PlantsManager>(
      plantsManager,
      dispose: (manager) => manager.dispose(),
    );

    final analysisManager = await AnalysisManager(
      userId: user.id,
      service: di<AnalysisDataSource>(),
      plantsManager: plantsManager,
    ).init();
    di.registerSingleton<AnalysisManager>(
      analysisManager,
      dispose: (manager) => manager.dispose(),
    );

    di.registerLazySingleton<CameraManager>(
      () => CameraManager(
        cameraService: di<CameraService>(),
        plantsManager: plantsManager,
        analysisManager: analysisManager,
      ),
    );

    di.registerLazySingleton<AiChatManager>(
      () => AiChatManager(
        chatService: di<AiChatService>(),
        plantsManager: plantsManager,
        analysisManager: analysisManager,
      ),
      dispose: (manager) => manager.dispose(),
    );

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
