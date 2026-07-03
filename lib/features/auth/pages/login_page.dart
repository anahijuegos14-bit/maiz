import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/widgets/app_button.dart';
import '../../../_shared/widgets/app_text_field.dart';
import '../../../app/routes.dart';
import '../manager/auth_manager.dart';
import '../model/login_request.dart';

class LoginPage extends WatchingStatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _resetEmailController = TextEditingController();
  bool _showReset = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _resetEmailController.dispose();
    super.dispose();
  }

  void _login() {
    di<AuthManager>().loginCommand.run(
          LoginRequest(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }

  void _sendReset() {
    di<AuthManager>().resetPasswordCommand.run(_resetEmailController.text);
    setState(() => _showReset = false);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((AuthManager m) => m.loginCommand.isRunning);
    final isSendingReset =
        watchValue((AuthManager m) => m.resetPasswordCommand.isRunning);
    final user = watchValue((AuthManager m) => m.userState);
    final colors = Theme.of(context).colorScheme;

    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => false,
        );
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 20),
                _HeaderIcon(
                  icon: _showReset
                      ? Icons.mark_email_unread_rounded
                      : Icons.eco_rounded,
                ),
                const SizedBox(height: 24),
                Text(
                  _showReset ? 'Recuperar contraseña' : 'Hola de nuevo',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  _showReset
                      ? 'Te enviaremos un enlace para restablecerla.'
                      : 'Ingresa para revisar tu cultivo.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
                const SizedBox(height: 22),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _showReset
                        ? Column(
                            children: [
                              AppTextField(
                                controller: _resetEmailController,
                                label: 'Correo electrónico',
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 14),
                              AppButton(
                                text: isSendingReset
                                    ? 'Enviando...'
                                    : 'Enviar enlace',
                                onPressed: isSendingReset ? null : _sendReset,
                              ),
                              const SizedBox(height: 6),
                              TextButton(
                                onPressed: () =>
                                    setState(() => _showReset = false),
                                child: const Text('Volver'),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              AppTextField(
                                controller: _emailController,
                                label: 'Correo electrónico',
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 12),
                              AppTextField(
                                controller: _passwordController,
                                label: 'Contraseña',
                                obscureText: true,
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    _resetEmailController.text =
                                        _emailController.text;
                                    setState(() => _showReset = true);
                                  },
                                  child:
                                      const Text('¿Olvidaste tu contraseña?'),
                                ),
                              ),
                              const SizedBox(height: 4),
                              AppButton(
                                text: isLoading
                                    ? 'Cargando...'
                                    : 'Iniciar sesión',
                                onPressed: isLoading ? null : _login,
                              ),
                            ],
                          ),
                  ),
                ),
                if (!_showReset) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '¿Sin cuenta? ',
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.register),
                        child: const Text('Regístrate'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;

  const _HeaderIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Icon(icon, color: colors.primary, size: 52),
      ),
    );
  }
}
