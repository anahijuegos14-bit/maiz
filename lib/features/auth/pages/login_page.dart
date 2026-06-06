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



  @override

  void dispose() {

    _emailController.dispose();

    _passwordController.dispose();

    _resetEmailController.dispose();

    super.dispose();

  }



  Future<void> _showResetPasswordDialog() async {

    _resetEmailController.text = _emailController.text;

    await showDialog<void>(

      context: context,

      builder: (context) => AlertDialog(

        title: const Text('Recuperar contraseña'),

        content: Column(

          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(

              'Te enviaremos un enlace para restablecerla.',

              style: Theme.of(context).textTheme.bodyMedium,

            ),

            const SizedBox(height: 16),

            AppTextField(

              controller: _resetEmailController,

              label: 'Correo electrónico',

            ),

          ],

        ),

        actions: [

          TextButton(

            onPressed: () => Navigator.pop(context),

            child: const Text('Cancelar'),

          ),

          FilledButton(

            onPressed: () {

              di<AuthManager>().resetPasswordCommand.run(

                    _resetEmailController.text,

                  );

              Navigator.pop(context);

            },

            child: const Text('Enviar enlace'),

          ),

        ],

      ),

    );

  }



  @override

  Widget build(BuildContext context) {

    final isLoading = watchValue((AuthManager m) => m.loginCommand.isRunning);

    final colors = Theme.of(context).colorScheme;



    return Scaffold(

      body: SafeArea(

        child: Center(

          child: ConstrainedBox(

            constraints: const BoxConstraints(maxWidth: 420),

            child: ListView(

              padding: const EdgeInsets.all(20),

              children: [

                const SizedBox(height: 10),

                Center(

                  child: Container(

                    width: 96,

                    height: 96,

                    decoration: BoxDecoration(

                      gradient: LinearGradient(

                        colors: [

                          colors.primaryContainer,

                          colors.tertiaryContainer,

                        ],

                      ),

                      borderRadius: BorderRadius.circular(28),

                    ),

                    child: Icon(

                      Icons.eco_rounded,

                      color: colors.primary,

                      size: 52,

                    ),

                  ),

                ),

                const SizedBox(height: 24),

                Center(

                  child: Text(

                    'Hola de nuevo',

                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(

                          fontWeight: FontWeight.bold,

                        ),

                  ),

                ),

                const SizedBox(height: 6),

                Text(

                  'Ingresa para revisar tu cultivo.',

                  textAlign: TextAlign.center,

                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(

                        color: colors.onSurfaceVariant,

                      ),

                ),

                const SizedBox(height: 24),

                Card(

                  child: Padding(

                    padding: const EdgeInsets.all(16),

                    child: Column(

                      children: [

                        AppTextField(

                          controller: _emailController,

                          label: 'Correo electrónico',

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

                            onPressed: _showResetPasswordDialog,

                            child: const Text('¿Olvidaste tu contraseña?'),

                          ),

                        ),

                        const SizedBox(height: 4),

                        AppButton(

                          text: isLoading ? 'Cargando...' : 'Iniciar sesión',

                          onPressed: isLoading

                              ? null

                              : () {

                                  di<AuthManager>().loginCommand.run(

                                        LoginRequest(

                                          email: _emailController.text,

                                          password: _passwordController.text,

                                        ),

                                      );

                                },

                        ),

                      ],

                    ),

                  ),

                ),

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
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
                      child: const Text('Regístrate'),
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


