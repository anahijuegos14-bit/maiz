/*import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app/features/ai/services/ai_chat_service.dart';
import 'package:mi_app/features/analysis/model/analysis_dto.dart';
import 'package:mi_app/features/plants/model/plant_dto.dart';
import 'package:mi_app/features/plants/model/plant_status.dart';

void main() {
  group('AiChatService (caja blanca)', () {
    final service = AiChatService();
    final plant = PlantDto(
      name: 'Maíz Parcela 1',
      variety: 'Amarillo H-512',
      location: 'Vereda San Pedro',
      notes: '',
      status: PlantStatus.enfermo,
      plantedDate: DateTime(2026, 5, 1),
      lastWateringDate: DateTime.now().subtract(const Duration(days: 8)),
      wateringHistory: [],
    );
    final analysis = AnalysisDto(
      plantId: 'p1',
      plantName: plant.name,
      type: AnalysisType.hoja,
      imageName: 'hoja.jpg',
      result: 'Enfermedad detectada',
      disease: 'Roya común',
      affectionPercent: 40,
      date: DateTime(2026, 6, 1),
      recommendations: const ['Aplicar fungicida foliar.'],
    );

    test('responde estado con contexto de planta y ultimo analisis', () {
      final response = service.generateResponse(
        userMessage: '¿Cómo está mi planta?',
        plant: plant,
        recentAnalyses: [analysis],
      );

      expect(response, contains('Maíz Parcela 1'));
      expect(response, contains('Roya común'));
      expect(response, contains('40%'));
    });

    test('responde tratamiento con recomendaciones del analisis', () {
      final response = service.generateResponse(
        userMessage: '¿Qué tratamiento recomiendas?',
        plant: plant,
        recentAnalyses: [analysis],
      );

      expect(response, contains('Aplicar fungicida'));
      expect(response, contains('Roya común'));
    });

    test('responde riego con dias desde ultimo riego', () {
      final response = service.generateResponse(
        userMessage: '¿Cuándo debería regar?',
        plant: plant,
      );

      expect(response, contains('Maíz Parcela 1'));
      expect(response.toLowerCase(), contains('riego'));
    });
  });
}*/
