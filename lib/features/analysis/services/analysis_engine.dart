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

/// Motor de detección simulado. Sustituir por modelo IA real en producción.
class AnalysisEngine {
  static const _diseases = [
    (
      name: 'Roya del maíz',
      summary: 'Manchas pardo-anaranjadas en hojas',
      recommendations: [
        'Aplicar fungicida a base de triazoles.',
        'Eliminar restos de cultivo infectados.',
        'Evitar riego por aspersión en horas frescas.',
      ],
    ),
    (
      name: 'Mancha gris (Cercospora)',
      summary: 'Lesiones rectangulares grisáceas',
      recommendations: [
        'Rotar con cultivos no susceptibles.',
        'Usar variedades tolerantes.',
        'Monitorear humedad del follaje.',
      ],
    ),
    (
      name: 'Tizón foliar',
      summary: 'Necrosis en bordes de hoja',
      recommendations: [
        'Mejorar drenaje del suelo.',
        'Aplicar fungicida preventivo.',
        'Reducir densidad de siembra.',
      ],
    ),
  ];

  static AnalysisResult analyze({
    required AnalysisType type,
    required String imageName,
  }) {
    final hash = imageName.hashCode.abs();
    final isHealthy = hash % 4 == 0;

    if (isHealthy) {
      return const AnalysisResult(
        summary: 'Cultivo saludable',
        disease: 'Cultivo saludable',
        affectionPercent: 0,
        recommendations: [
          'Mantén monitoreo semanal del follaje.',
          'Continúa con riego y fertilización según etapa fenológica.',
        ],
      );
    }

    final disease = _diseases[hash % _diseases.length];
    final affection = 15.0 + (hash % 70);

    return AnalysisResult(
      summary: type == AnalysisType.hoja
          ? 'Enfermedad detectada en hoja: ${disease.name}'
          : 'Zona afectada en terreno: ${disease.name}',
      disease: disease.name,
      affectionPercent: affection,
      recommendations: disease.recommendations,
    );
  }
}
