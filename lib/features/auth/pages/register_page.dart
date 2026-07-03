import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/widgets/app_button.dart';
import '../../../_shared/widgets/app_text_field.dart';
import '../../../app/routes.dart';
import '../manager/auth_manager.dart';
import '../model/register_request.dart';

class RegisterPage extends WatchingStatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _passwordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    final password = _passwordController.text;
    if (password.length < 6) {
      setState(() => _passwordError = 'Mínimo 6 caracteres.');
      return;
    }
    setState(() => _passwordError = null);

    di<AuthManager>().registerCommand.run(
          RegisterRequest(
            email: _emailController.text,
            password: password,
            name: _nameController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((AuthManager m) => m.registerCommand.isRunning);
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
                const SizedBox(height: 22),
                Center(
                  child: Container(
                    height: 92,
                    width: 92,
                    decoration: BoxDecoration(
                      color: colors.tertiaryContainer,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Icon(
                      Icons.local_florist_rounded,
                      color: colors.tertiary,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Crear cuenta',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Empieza a cuidar tu maíz hoy.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        AppTextField(
                          controller: _nameController,
                          label: 'Nombre completo',
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: _emailController,
                          label: 'Correo electrónico',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: _passwordController,
                          label: 'Contraseña (mínimo 6 caracteres)',
                          obscureText: true,
                        ),
                        if (_passwordError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              _passwordError!,
                              style: TextStyle(color: colors.error),
                            ),
                          ),
                        const SizedBox(height: 14),
                        AppButton(
                          text: isLoading ? 'Creando...' : 'Crear cuenta',
                          onPressed: isLoading ? null : _register,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '¿Ya tienes cuenta? ',
                      style: TextStyle(color: colors.onSurfaceVariant),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.login,
                      ),
                      child: const Text('Inicia sesión'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
