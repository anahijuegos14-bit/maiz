import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../analysis/manager/analysis_manager.dart';
import '../../analysis/model/analysis_dto.dart';

enum HistoryFilter { todos, hoja, terreno }

class HistoryPage extends WatchingStatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  HistoryFilter _filter = HistoryFilter.todos;

  @override
  Widget build(BuildContext context) {
    final analyses = watchValue((AnalysisManager m) => m.analyses);
    final colors = Theme.of(context).colorScheme;

    final filtered = analyses.where((entry) {
      switch (_filter) {
        case HistoryFilter.todos:
          return true;
        case HistoryFilter.hoja:
          return entry.dto.type == AnalysisType.hoja;
        case HistoryFilter.terreno:
          return entry.dto.type == AnalysisType.terreno;
      }
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        SegmentedButton<HistoryFilter>(
          segments: const [
            ButtonSegment(value: HistoryFilter.todos, label: Text('Todos')),
            ButtonSegment(value: HistoryFilter.hoja, label: Text('Hoja')),
            ButtonSegment(value: HistoryFilter.terreno, label: Text('Terreno')),
          ],
          selected: {_filter},
          onSelectionChanged: (value) =>
              setState(() => _filter = value.first),
        ),
        const SizedBox(height: 16),
        if (filtered.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No hay análisis registrados.',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
            ),
          )
        else
          ...filtered.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AnalysisHistoryCard(entry: entry),
            ),
          ),
      ],
    );
  }
}

class _AnalysisHistoryCard extends StatelessWidget {
  final AnalysisEntry entry;

  const _AnalysisHistoryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final dto = entry.dto;
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    dto.type == AnalysisType.hoja
                        ? Icons.eco_rounded
                        : Icons.landscape_rounded,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dto.plantName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        dto.result,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoTag(
                  label: dto.isHealthy ? 'Cultivo saludable' : dto.disease,
                ),
                _InfoTag(
                  label: '${dto.affectionPercent.toStringAsFixed(0)}% afectación',
                ),
                _InfoTag(label: _formatDate(dto.date)),
                _InfoTag(label: dto.type.label),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _showRecommendations(context, dto),
                child: const Text('Ver recomendaciones'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRecommendations(BuildContext context, AnalysisDto dto) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recomendaciones',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...dto.recommendations.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(r)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }
}

class _InfoTag extends StatelessWidget {
  final String label;

  const _InfoTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      visualDensity: VisualDensity.compact,
    );
  }
}
