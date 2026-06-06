import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app/features/auth/services/firebase_auth_service.dart';

void main() {
  group('FirebaseAuthService (caja blanca)', () {
    test('mapUser usa displayName cuando existe', () {
      final auth = FirebaseAuthService(
        MockFirebaseAuth(
          mockUser: MockUser(
            uid: 'uid-1',
            email: 'grower@test.com',
            displayName: 'Ana Grower',
          ),
          signedIn: true,
        ),
      );

      final user = auth.firebaseAuth.currentUser!;
      final appUser = auth.mapUser(user);

      expect(appUser.id, 'uid-1');
      expect(appUser.email, 'grower@test.com');
      expect(appUser.name, 'Ana Grower');
    });

    test('mapUser cae en email cuando no hay displayName', () {
      final auth = FirebaseAuthService(
        MockFirebaseAuth(
          mockUser: MockUser(
            uid: 'uid-2',
            email: 'solo@test.com',
          ),
          signedIn: true,
        ),
      );

      final user = auth.firebaseAuth.currentUser!;
      final appUser = auth.mapUser(user);

      expect(appUser.name, 'solo@test.com');
    });
  });

  group('mapFirebaseAuthError (caja blanca)', () {
    test('traduce codigos conocidos de Firebase', () {
      expect(
        mapFirebaseAuthError(
          FirebaseAuthException(code: 'invalid-email'),
        ),
        'Correo inválido.',
      );
      expect(
        mapFirebaseAuthError(
          FirebaseAuthException(code: 'wrong-password'),
        ),
        'Credenciales incorrectas.',
      );
      expect(
        mapFirebaseAuthError(
          FirebaseAuthException(code: 'email-already-in-use'),
        ),
        'Este correo ya está registrado.',
      );
      expect(
        mapFirebaseAuthError(
          FirebaseAuthException(code: 'weak-password'),
        ),
        'La contraseña debe tener al menos 6 caracteres.',
      );
    });

    test('usa mensaje de Firebase o generico en codigo desconocido', () {
      expect(
        mapFirebaseAuthError(
          FirebaseAuthException(
            code: 'operation-not-allowed',
            message: 'Operacion no permitida.',
          ),
        ),
        'Operacion no permitida.',
      );
      expect(
        mapFirebaseAuthError(FirebaseAuthException(code: 'unknown')),
        'Error de autenticación.',
      );
    });
  });
}
