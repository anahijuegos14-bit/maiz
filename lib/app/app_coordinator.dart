import 'package:command_it/command_it.dart';
import 'package:watch_it/watch_it.dart';

import '../_shared/errors/exceptions.dart';
import '../_shared/services/interaction_manager.dart';

class AppCoordinator {
  AppCoordinator._();

  static void globalErrorHandler(
    CommandError<dynamic> error,
    StackTrace stackTrace,
  ) {
    final underlying = error.error;
    final message = underlying is ServerException
        ? underlying.message
        : underlying.toString();
    di<InteractionManager>().showSnackBar(message, isError: true);
  }
}
