import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../app/routes.dart';
import '../manager/plants_manager.dart';
import 'plant_detail_page.dart';

class PlantsPage extends WatchingWidget {
  const PlantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final plants = watchValue((PlantsManager m) => m.plants);
    final colors = Theme.of(context).colorScheme;

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mis Plantas',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${plants.length} plantas registradas',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.plantForm),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Nueva Planta'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (plants.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(Icons.spa_outlined, size: 48, color: colors.primary),
                      const SizedBox(height: 12),
                      Text(
                        'Aún no tienes plantas registradas',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Presiona Nueva Planta para comenzar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...plants.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colors.primaryContainer,
                        child: Icon(Icons.grass_rounded, color: colors.primary),
                      ),
                      title: Text(
                        entry.dto.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${entry.dto.variety.isNotEmpty ? entry.dto.variety : "Sin variedad"} · '
                        '${entry.dto.status.label}',
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlantDetailPage(
                              plantId: entry.id,
                              plant: entry.dto,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
