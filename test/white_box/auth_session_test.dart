import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_app/_shared/services/interaction_manager.dart';
import 'package:mi_app/features/auth/model/app_user.dart';

void main() {
  group('Sesion de usuario con GetIt (caja blanca)', () {
    test('pushNewScope registra AppUser y popScope lo elimina', () async {
      final locator = GetIt.asNewInstance();
      locator.registerSingleton<InteractionManager>(InteractionManager());

      locator.pushNewScope(
        scopeName: 'user-session',
        init: (scope) {
          scope.registerSingleton<AppUser>(
            const AppUser(id: 'u1', email: 'a@test.com', name: 'Test'),
          );
        },
      );

      expect(locator<AppUser>().email, 'a@test.com');

      await locator.popScope();

      expect(locator.isRegistered<AppUser>(), isFalse);
      await locator.reset();
    });
  });
}
