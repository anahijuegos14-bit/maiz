import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/widgets/authenticated_shell.dart';
import '../../analysis/manager/analysis_manager.dart';
import '../manager/plants_manager.dart';
import '../model/plant_dto.dart';
import '../model/plant_status.dart';

class PlantDetailPage extends WatchingWidget {
  final String plantId;
  final PlantDto plant;

  const PlantDetailPage({
    super.key,
    required this.plantId,
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    final manager = di<PlantsManager>();
    final analyses = watchValue((AnalysisManager m) => m.analyses);
    final colors = Theme.of(context).colorScheme;

    final plantAnalyses = analyses
        .where((a) => a.dto.plantId == plantId)
        .map((e) => e.dto)
        .toList();

    return AuthenticatedShell(
      child: Scaffold(
        appBar: AppBar(
          title: Text(plant.name),
          actions: [
            IconButton(
              tooltip: 'Eliminar',
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () => _confirmDelete(context, manager),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () => _registerWatering(context, manager),
                  icon: const Icon(Icons.water_drop_rounded, size: 20),
                  label: const Text('Regar'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _showEditDialog(context, manager),
                  icon: const Icon(Icons.edit_rounded, size: 20),
                  label: const Text('Editar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Resumen de Planta',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _DetailRow(label: 'Nombre', value: plant.name),
                    _DetailRow(
                      label: 'Variedad',
                      value: plant.variety.isEmpty ? '—' : plant.variety,
                    ),
                    _DetailRow(
                      label: 'Ubicación',
                      value: plant.displayLocation.isEmpty
                          ? '—'
                          : plant.displayLocation,
                    ),
                    _DetailRow(
                      label: 'Fecha de siembra',
                      value: _formatDate(plant.plantedDate),
                    ),
                    _DetailRow(
                      label: 'Área',
                      value: plant.areaHectares > 0
                          ? '${plant.areaHectares} ha'
                          : '—',
                    ),
                    _DetailRow(label: 'Estado', value: plant.status.label),
                    if (plant.notes.isNotEmpty)
                      _DetailRow(label: 'Observaciones', value: plant.notes),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Historial de análisis',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            if (plantAnalyses.isEmpty)
              Text(
                'Sin análisis registrados.',
                style: TextStyle(color: colors.onSurfaceVariant),
              )
            else
              ...plantAnalyses.map(
                (a) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    a.isHealthy ? Icons.check_circle_outline : Icons.warning_amber,
                    color: a.isHealthy ? colors.primary : colors.error,
                  ),
                  title: Text(a.disease),
                  subtitle: Text(
                    '${a.affectionPercent.toStringAsFixed(0)}% · ${_formatDate(a.date)}',
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              'Historial de riegos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            if (plant.wateringHistory.isEmpty)
              Text(
                'Sin riegos registrados.',
                style: TextStyle(color: colors.onSurfaceVariant),
              )
            else
              ...plant.wateringHistory.map(
                (date) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.opacity_rounded, color: colors.primary),
                  title: Text(_formatDate(date)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerWatering(
    BuildContext context,
    PlantsManager manager,
  ) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2018),
      lastDate: DateTime(now.year + 2),
    );
    if (selected == null) return;
    manager.updateWateringCommand.run(
      WateringUpdateRequest(
        plantId: plantId,
        current: plant,
        wateringDate: selected,
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    PlantsManager manager,
  ) async {
    final nameController = TextEditingController(text: plant.name);
    final varietyController = TextEditingController(text: plant.variety);
    final locationController = TextEditingController(text: plant.displayLocation);
    var status = plant.status;

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Editar planta'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: varietyController,
                  decoration: const InputDecoration(labelText: 'Variedad'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Ubicación'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<PlantStatus>(
                  initialValue: status,
                  decoration: const InputDecoration(labelText: 'Estado'),
                  items: PlantStatus.values
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.label),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setDialogState(() => status = v);
                  },
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close_rounded),
            ),
            FilledButton(
              onPressed: () {
                manager.savePlantCommand.run(
                  PlantSaveRequest(
                    id: plantId,
                    dto: plant.copyWith(
                      name: nameController.text.trim(),
                      variety: varietyController.text.trim(),
                      placeName: locationController.text.trim(),
                      location: locationController.text.trim(),
                      status: status,
                    ),
                  ),
                );
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
    varietyController.dispose();
    locationController.dispose();
  }

  Future<void> _confirmDelete(
    BuildContext context,
    PlantsManager manager,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar planta'),
        content: Text(
          '¿Estás seguro de eliminar "${plant.name}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && context.mounted) {
      manager.deletePlantCommand.run(plantId);
      Navigator.pop(context);
    }
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
