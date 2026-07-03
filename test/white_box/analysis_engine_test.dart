import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app/features/analysis/model/analysis_dto.dart';
import 'package:mi_app/features/analysis/services/analysis_engine.dart';

void main() {
  group('AnalysisEngine (caja blanca)', () {
    test('analisis de hoja retorna roya comun con 40 por ciento', () {
      final result = AnalysisEngine.analyze(
        type: AnalysisType.hoja,
        imageName: 'hoja.jpg',
      );

      expect(result.disease, 'Roya común');
      expect(result.affectionPercent, 40);
      expect(result.summary, contains('hoja'));
      expect(result.recommendations, isNotEmpty);
      expect(result.isHealthy, isFalse);
    });

    test('analisis de terreno conserva recomendaciones agronomicas', () {
      final result = AnalysisEngine.analyze(
        type: AnalysisType.terreno,
        imageName: 'terreno.jpg',
      );

      expect(result.summary, contains('terreno'));
      expect(result.recommendations.length, greaterThanOrEqualTo(3));
      expect(
        result.recommendations.join(' ').toLowerCase(),
        contains('fungicida'),
      );
    });
  });
}
