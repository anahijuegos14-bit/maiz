import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../ai/manager/ai_chat_manager.dart';
import '../../plants/manager/plants_manager.dart';

class FloatingAiChat extends WatchingStatefulWidget {
  const FloatingAiChat({super.key});

  @override
  State<FloatingAiChat> createState() => _FloatingAiChatState();
}

class _FloatingAiChatState extends State<FloatingAiChat> {
  bool _isOpen = false;
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
    if (!di.isRegistered<AiChatManager>()) return;
    try {
      di<AiChatManager>().sendMessage(text);
    } on StateError {
      // Manager o sus dependencias aún no están listos
      return;
    }
    _messageController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Evita acceder a managers no registrados o no listos.
    if (!di.isRegistered<AiChatManager>() || !di.isRegistered<PlantsManager>()) {
      return const SizedBox.shrink();
    }

    late final AiChatManager manager;
    try {
      manager = di<AiChatManager>();
    } on StateError {
      return const SizedBox.shrink();
    }

    // Observar valores sólo después de asegurarnos que el manager está listo.
    // Anotaciones explícitas para evitar 'prefer_typing_uninitialized_variables'
    late final List<dynamic> messages;
    late final List<dynamic> plants;
    late final String? selectedPlantId;
    try {
      messages = watchValue((AiChatManager m) => m.messages);
      plants = watchValue((PlantsManager m) => m.plants);
      selectedPlantId = watchValue((AiChatManager m) => m.selectedPlantId);
    } on StateError {
      return const SizedBox.shrink();
    }
    final colors = Theme.of(context).colorScheme;

    return Stack(
      children: [
        if (_isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _isOpen = false),
              child: Container(color: Colors.black26),
            ),
          ),
        if (_isOpen)
          Positioned(
            left: 16,
            right: 16,
            bottom: 164,
            top: 80,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: colors.primaryContainer,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chat con IA',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Asistente agrónomo personalizado.',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _isOpen = false),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: DropdownButtonFormField<String?>(
                      initialValue: selectedPlantId,
                      decoration: const InputDecoration(
                        labelText: 'Planta a consultar',
                      ),
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
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (_, index) {
                        final msg = messages[index];
                        return Align(
                          alignment: msg.isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              color: msg.isUser
                                  ? colors.primary
                                  : colors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              msg.text,
                              style: TextStyle(
                                color: msg.isUser
                                    ? colors.onPrimary
                                    : colors.onSurface,
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
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Pregunta sobre tu cultivo...',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
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
              ),
            ),
          ),
        Positioned(
          right: 16,
          bottom: 92,
          child: FloatingActionButton(
            onPressed: () => setState(() => _isOpen = !_isOpen),
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            child: Icon(_isOpen ? Icons.close_rounded : Icons.chat_rounded),
          ),
        ),
      ],
    );
  }
}
