import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/camera_manager.dart';

class CameraPage extends WatchingWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<CameraManager>();
    final plants = watchValue((CameraManager m) => m.plants);
    final image = watchValue((CameraManager m) => m.capturedImage);
    final plantId = watchValue((CameraManager m) => m.selectedPlantId);
    final isPicking = watchValue((CameraManager m) => m.pickFromCameraCommand.isRunning);
    final isAnalyzing = watchValue((CameraManager m) => m.analyzeCommand.isRunning);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Camara')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Capturar imagen',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isPicking ? null : () => manager.pickFromCameraCommand.run(),
                      icon: const Icon(Icons.photo_camera_rounded),
                      label: Text(
                        image == null ? 'Abrir camara' : 'Tomar nueva foto',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      image == null
                          ? 'Aun no has tomado una foto.'
                          : 'Foto capturada: ${image.name}',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selecciona la planta',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  if (plants.isEmpty)
                    Text(
                      'Aun no tienes plantas registradas en la base de datos.',
                      style: TextStyle(color: colors.onSurfaceVariant),
                    )
                  else
                    DropdownButtonFormField<String>(
                      initialValue: plantId,
                      items: plants
                          .map(
                            (entry) => DropdownMenuItem<String>(
                              value: entry.id,
                              child: Text(entry.dto.name),
                            ),
                          )
                          .toList(),
                      decoration: const InputDecoration(
                        labelText: 'Planta asociada',
                      ),
                      onChanged: manager.selectPlant,
                    ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: (image == null || plantId == null || isAnalyzing)
                          ? null
                          : () => manager.analyzeCommand.run(),
                      icon: const Icon(Icons.science_outlined),
                      label: Text(
                        isAnalyzing
                            ? 'Procesando...'
                            : 'Continuar al analisis IA',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
