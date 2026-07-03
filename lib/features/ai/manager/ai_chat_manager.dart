import 'package:flutter/foundation.dart';

import '../../analysis/manager/analysis_manager.dart';
import '../../plants/manager/plants_manager.dart';
import '../../plants/model/plant_dto.dart';
import '../services/ai_chat_service.dart';

class AiChatManager {
  AiChatManager({
    required AiChatService chatService,
    required PlantsManager plantsManager,
    required AnalysisManager analysisManager,
  })  : _chatService = chatService,
        _plantsManager = plantsManager,
        _analysisManager = analysisManager;

  final AiChatService _chatService;
  final PlantsManager _plantsManager;
  final AnalysisManager _analysisManager;

  final messages = ValueNotifier<List<ChatMessage>>([
    ChatMessage(
      text:
          '¡Hola! 🌽 Soy tu asistente agrónomo. Selecciona una planta para que pueda ver su estado y darte consejos personalizados, o pregúntame lo que quieras sobre maíz.',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ]);

  final selectedPlantId = ValueNotifier<String?>(null);

  ValueListenable<List<PlantEntry>> get plants => _plantsManager.plants;

  void selectPlant(String? plantId) {
    selectedPlantId.value = plantId;
  }

  void sendMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    PlantDto? plant;
    final plantId = selectedPlantId.value;
    if (plantId != null) {
      for (final entry in _plantsManager.plants.value) {
        if (entry.id == plantId) {
          plant = entry.dto;
          break;
        }
      }
    }

    final response = _chatService.generateResponse(
      userMessage: trimmed,
      plant: plant,
      recentAnalyses: _analysisManager.analyses.value.map((e) => e.dto).toList(),
    );

    messages.value = [
      ...messages.value,
      ChatMessage(
        text: trimmed,
        isUser: true,
        timestamp: DateTime.now(),
      ),
      ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
  }

  void dispose() {
    messages.dispose();
    selectedPlantId.dispose();
  }
}
