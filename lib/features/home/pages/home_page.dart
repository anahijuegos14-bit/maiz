import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/widgets/authenticated_shell.dart';
import '../../analysis/manager/analysis_manager.dart';
import '../../analysis/model/analysis_dto.dart';
import '../../analysis/pages/analysis_flow_page.dart';
import '../../auth/manager/auth_manager.dart';
import '../../diseases/pages/diseases_info_page.dart';
import '../../history/pages/history_page.dart';
import '../../plants/manager/plants_manager.dart';
import '../../plants/model/plant_status.dart';
import '../../plants/pages/plants_page.dart';

class HomePage extends WatchingStatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días Agricultor';
    if (hour < 19) return 'Buenas tardes Agricultor';
    return 'Buenas noches Agricultor';
  }

  @override
  Widget build(BuildContext context) {
    final isLoggingOut =
        watchValue((AuthManager m) => m.logoutCommand.isRunning);

    final pages = [
      _DashboardView(onOpenTab: (index) => setState(() => _index = index)),
      const PlantsPage(),
      const AnalysisFlowPage(embedded: true),
      const HistoryPage(),
      const DiseasesInfoPage(),
    ];

    return AuthenticatedShell(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_greeting()),
          actions: [
            TextButton.icon(
              onPressed:
                  isLoggingOut ? null : () => di<AuthManager>().logoutCommand.run(),
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: Text(isLoggingOut ? 'Saliendo...' : 'Cerrar sesión'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: pages[_index],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          height: 76,
          onDestinationSelected: (value) => setState(() => _index = value),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.spa_outlined),
              selectedIcon: Icon(Icons.spa_rounded),
              label: 'Mis Plantas',
            ),
            NavigationDestination(
              icon: _MainAnalysisIcon(selected: false),
              selectedIcon: _MainAnalysisIcon(selected: true),
              label: 'Nuevo',
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              selectedIcon: Icon(Icons.assignment_rounded),
              label: 'Historial',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book_rounded),
              label: 'Biblioteca',
            ),
          ],
        ),
      ),
    );
  }
}

class _MainAnalysisIcon extends StatelessWidget {
  final bool selected;

  const _MainAnalysisIcon({required this.selected});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: selected ? 44 : 40,
      height: selected ? 44 : 40,
      decoration: BoxDecoration(
        color: selected ? colors.primary : colors.tertiaryContainer,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.add_a_photo_rounded,
        color: selected ? colors.onPrimary : colors.tertiary,
        size: selected ? 25 : 23,
      ),
    );
  }
}

class _DashboardView extends WatchingWidget {
  final ValueChanged<int> onOpenTab;

  const _DashboardView({required this.onOpenTab});

  @override
  Widget build(BuildContext context) {
    if (!sessionReady()) {
      return const Center(child: CircularProgressIndicator());
    }

    final plants = watchValue((PlantsManager m) => m.plants);
    final analyses = watchValue((AnalysisManager m) => m.analyses);
    final colors = Theme.of(context).colorScheme;

    final atRisk = plants.where((p) => p.dto.status.isAtRisk).length;
    final healthy =
        plants.where((p) => p.dto.status == PlantStatus.saludable).length;
    final recent = analyses.take(5).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        Text(
          'Resumen General',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            _StatCard(
              label: 'Análisis',
              value: '${analyses.length}',
              icon: Icons.analytics_outlined,
              color: colors.primary,
            ),
            _StatCard(
              label: 'Plantas',
              value: '${plants.length}',
              icon: Icons.spa_outlined,
              color: colors.tertiary,
            ),
            _StatCard(
              label: 'En Riesgo',
              value: '$atRisk',
              icon: Icons.warning_amber_rounded,
              color: colors.error,
            ),
            _StatCard(
              label: 'Saludables',
              value: '$healthy',
              icon: Icons.check_circle_outline_rounded,
              color: const Color(0xFF2E7D32),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Acciones Rápidas',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _ActionTile(
              title: 'Analizar',
              subtitle: 'Hoja o terreno',
              icon: Icons.biotech_rounded,
              onTap: () => onOpenTab(2),
            ),
            _ActionTile(
              title: 'Registrar Planta',
              subtitle: 'Nueva siembra',
              icon: Icons.add_circle_outline_rounded,
              onTap: () => onOpenTab(1),
            ),
            _ActionTile(
              title: 'Historial',
              subtitle: 'Ver análisis anteriores',
              icon: Icons.history_rounded,
              onTap: () => onOpenTab(3),
            ),
            _ActionTile(
              title: 'Biblioteca',
              subtitle: 'Enfermedades del maíz',
              icon: Icons.menu_book_rounded,
              onTap: () => onOpenTab(4),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text(
                'Detecciones Recientes',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => onOpenTab(2),
              child: const Text('Comenzar análisis'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (recent.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Aún no hay análisis. Comienza uno para detectar enfermedades.',
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
            ),
          )
        else
          ...recent.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: entry.dto.isHealthy
                        ? colors.primaryContainer
                        : colors.errorContainer,
                    child: Icon(
                      entry.dto.isHealthy
                          ? Icons.check_rounded
                          : Icons.coronavirus_rounded,
                      color: entry.dto.isHealthy ? colors.primary : colors.error,
                    ),
                  ),
                  title: Text(entry.dto.plantName),
                  subtitle: Text(
                    '${entry.dto.disease} · '
                    '${entry.dto.affectionPercent.toStringAsFixed(0)}% · '
                    '${_formatDate(entry.dto.date)}',
                  ),
                  trailing: Chip(label: Text(entry.dto.type.label)),
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const Spacer(),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: colors.primary),
              const Spacer(),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
