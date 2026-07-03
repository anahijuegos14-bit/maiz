import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/ai_chat_manager.dart';

class AIChatPage extends WatchingStatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final _messageController = TextEditingController();

  static const _quickQuestions = [
    '¿Cómo está mi planta?',
    '¿Qué tratamiento recomiendas?',
    '¿Cuándo debería regar?',
    'Plagas comunes en maíz',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _send(String text) {
    di<AiChatManager>().sendMessage(text);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (!di.isRegistered<AiChatManager>()) {
      return const Center(child: CircularProgressIndicator());
    }

    final manager = di<AiChatManager>();
    final messages = watchValue((AiChatManager m) => m.messages);
    final plants = watchValue((AiChatManager m) => m.plants);
    final selectedPlantId = watchValue((AiChatManager m) => m.selectedPlantId);
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chat con IA',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Asistente agrónomo personalizado.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                initialValue: selectedPlantId,
                decoration: const InputDecoration(labelText: 'Planta a consultar'),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Sin planta específica'),
                  ),
                  ...plants.map(
                    (entry) => DropdownMenuItem<String?>(
                      value: entry.id,
                      child: Text(entry.dto.name),
                    ),
                  ),
                ],
                onChanged: manager.selectPlant,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            itemCount: messages.length,
            itemBuilder: (_, index) {
              final msg = messages[index];
              return Align(
                alignment:
                    msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.78,
                  ),
                  decoration: BoxDecoration(
                    color:
                        msg.isUser ? colors.primary : colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      color: msg.isUser ? colors.onPrimary : colors.onSurface,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _quickQuestions
                .map(
                  (q) => ActionChip(
                    label: Text(q, style: const TextStyle(fontSize: 12)),
                    onPressed: () => _send(q),
                  ),
                )
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Pregunta sobre tu cultivo...',
                  ),
                  onSubmitted: _send,
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => _send(_messageController.text),
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
