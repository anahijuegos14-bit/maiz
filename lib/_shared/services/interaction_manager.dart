import 'package:flutter/material.dart';

class InteractionManager {
  BuildContext? _context;

  void setContext(BuildContext context) => _context = context;

  BuildContext? get stableContext {
    final ctx = _context;
    if (ctx != null && ctx.mounted) return ctx;
    return null;
  }

  void showSnackBar(String message, {bool isError = false}) {
    final ctx = stableContext;
    if (ctx == null) return;
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(ctx).colorScheme.error : null,
      ),
    );
  }
}
