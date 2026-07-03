import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../features/ai/manager/ai_chat_manager.dart';
import '../../features/ai/widgets/floating_ai_chat.dart';
import '../../features/analysis/manager/analysis_manager.dart';
import '../../features/auth/manager/auth_manager.dart';
import '../../features/plants/manager/plants_manager.dart';

/// Envuelve pantallas autenticadas con el botón flotante de chat IA.
class AuthenticatedShell extends WatchingWidget {
  final Widget child;

  const AuthenticatedShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final user = watchValue((AuthManager m) => m.userState);
    if (user == null) return child;

    return Stack(
      children: [
        child,
        const FloatingAiChat(),
      ],
    );
  }
}

/// Verifica que los managers de sesión estén listos.
bool sessionReady() {
  return di.isRegistered<PlantsManager>() &&
      di.isRegistered<AnalysisManager>() &&
      di.isRegistered<AiChatManager>();
}
