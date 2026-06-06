import 'package:firebase_auth/firebase_auth.dart';

import '../../../_shared/errors/exceptions.dart';
import '../model/app_user.dart';

class FirebaseAuthService {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthService(this.firebaseAuth);

  Stream<User?> authStateChanges() => firebaseAuth.authStateChanges();

  User? get currentUser => firebaseAuth.currentUser;

  AppUser mapUser(User user) {
    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? user.email ?? 'Usuario',
    );
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw ServerException('No se pudo iniciar sesión.');
      }
      return mapUser(user);
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapError(e));
    }
  }

  Future<AppUser> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw ServerException('No se pudo crear la cuenta.');
      }
      await user.updateDisplayName(name);
      await user.reload();
      final refreshedUser = firebaseAuth.currentUser;
      if (refreshedUser == null) {
        throw ServerException('No se pudo actualizar el perfil.');
      }
      return mapUser(refreshedUser);
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapError(e));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapError(e));
    }
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  String _mapError(FirebaseAuthException e) => mapFirebaseAuthError(e);
}

String mapFirebaseAuthError(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'Correo inválido.';
    case 'invalid-credential':
    case 'wrong-password':
    case 'user-not-found':
      return 'Credenciales incorrectas.';
    case 'email-already-in-use':
      return 'Este correo ya está registrado.';
    case 'weak-password':
      return 'La contraseña debe tener al menos 6 caracteres.';
    default:
      return e.message ?? 'Error de autenticación.';
  }
}
