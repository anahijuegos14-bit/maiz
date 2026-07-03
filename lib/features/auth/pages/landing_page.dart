import 'package:flutter/material.dart';

import '../../../_shared/widgets/app_button.dart';
import '../../../app/routes.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer.withValues(alpha: 0.82),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 132,
                        height: 132,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: colors.primary.withValues(alpha: 0.18),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.eco_rounded,
                              size: 82,
                              color: colors.primary,
                            ),
                            Positioned(
                              right: 22,
                              bottom: 22,
                              child: Icon(
                                Icons.auto_awesome_rounded,
                                color: colors.tertiary,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'IA que cuida tu maíz hoja por hoja',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Detecta enfermedades, gestiona tus plantas y recibe recomendaciones específicas para proteger tu cosecha.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: colors.onSurfaceVariant,
                              height: 1.45,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: _BenefitPill(
                        icon: Icons.biotech_rounded,
                        label: 'Detección',
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _BenefitPill(
                        icon: Icons.spa_rounded,
                        label: 'Cultivo',
                        color: colors.tertiary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _BenefitPill(
                        icon: Icons.chat_rounded,
                        label: 'Consejos',
                        color: colors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                AppButton(
                  text: 'Crear cuenta gratis',
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                    child: const Text('Ya tengo cuenta'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BenefitPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _BenefitPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          FittedBox(
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
