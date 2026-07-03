import '../model/analysis_dto.dart';

class AnalysisResult {
  final String summary;
  final String disease;
  final double affectionPercent;
  final List<String> recommendations;

  const AnalysisResult({
    required this.summary,
    required this.disease,
    required this.affectionPercent,
    required this.recommendations,
  });

  bool get isHealthy =>
      disease.isEmpty || disease.toLowerCase().contains('saludable');
}

/// Motor simulado mientras se conecta el modelo IA real.
class AnalysisEngine {
  static AnalysisResult analyze({
    required AnalysisType type,
    required String imageName,
  }) {
    return AnalysisResult(
      summary: type == AnalysisType.hoja
          ? 'Enfermedad detectada en hoja: Roya común'
          : 'Zona afectada en terreno: Roya común',
      disease: 'Roya común',
      affectionPercent: 40,
      recommendations: const [
        'Aplicar fungicida foliar a base de triazoles o estrobilurinas durante los próximos 2 a 3 días.',
        'Revisar hojas nuevas cada 48 horas y repetir análisis en 7 días para confirmar evolución.',
        'Evitar riego por aspersión al final de la tarde para reducir humedad nocturna en el follaje.',
        'Retirar residuos vegetales muy infectados y mejorar ventilación entre plantas.',
      ],
    );
  }
}
