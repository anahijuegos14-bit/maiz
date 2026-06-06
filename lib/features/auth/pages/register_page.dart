import 'package:flutter/material.dart';

import 'package:watch_it/watch_it.dart';



import '../../../_shared/widgets/app_button.dart';

import '../../../_shared/widgets/app_text_field.dart';

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

    final colors = Theme.of(context).colorScheme;



    return Scaffold(

      body: SafeArea(

        child: Center(

          child: ConstrainedBox(

            constraints: const BoxConstraints(maxWidth: 420),

            child: ListView(

              padding: const EdgeInsets.all(20),

              children: [

                const SizedBox(height: 24),

                Center(

                  child: Container(

                    height: 84,

                    width: 84,

                    decoration: BoxDecoration(

                      gradient: LinearGradient(

                        colors: [

                          colors.primaryContainer,

                          colors.tertiaryContainer,

                        ],

                      ),

                      borderRadius: BorderRadius.circular(24),

                    ),

                    child: Icon(

                      Icons.local_florist_rounded,

                      color: colors.primary,

                      size: 48,

                    ),

                  ),

                ),

                const SizedBox(height: 20),

                Center(

                  child: Text(

                    'Crear cuenta',

                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(

                          fontWeight: FontWeight.bold,

                        ),

                  ),

                ),

                const SizedBox(height: 6),

                Text(

                  'Empieza a cuidar tu maíz hoy.',

                  textAlign: TextAlign.center,

                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(

                        color: colors.onSurfaceVariant,

                      ),

                ),

                const SizedBox(height: 18),

                Card(

                  child: Padding(

                    padding: const EdgeInsets.all(16),

                    child: Column(

                      children: [

                        AppTextField(

                          controller: _nameController,

                          label: 'Nombre completo',

                        ),

                        const SizedBox(height: 12),

                        AppTextField(

                          controller: _emailController,

                          label: 'Correo electrónico',

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

                        const SizedBox(height: 10),

                        AppButton(

                          text: isLoading ? 'Creando...' : 'Crear cuenta',

                          onPressed: isLoading ? null : _register,

                        ),

                      ],

                    ),

                  ),

                ),

                const SizedBox(height: 8),

                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '¿Ya tienes cuenta? ',
                      style: TextStyle(color: colors.onSurfaceVariant),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
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


