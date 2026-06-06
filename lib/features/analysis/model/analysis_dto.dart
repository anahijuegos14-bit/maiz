import 'package:cloud_firestore/cloud_firestore.dart';

enum AnalysisType { hoja, terreno }

extension AnalysisTypeLabel on AnalysisType {
  String get label => this == AnalysisType.hoja ? 'Hoja' : 'Terreno';

  String get storageKey => this == AnalysisType.hoja ? 'hoja' : 'terreno';

  static AnalysisType fromString(String? value) {
    return value == 'terreno' ? AnalysisType.terreno : AnalysisType.hoja;
  }
}

class AnalysisDto {
  final String plantId;
  final String plantName;
  final AnalysisType type;
  final String imageName;
  final String result;
  final String disease;
  final double affectionPercent;
  final DateTime date;
  final List<String> recommendations;

  const AnalysisDto({
    required this.plantId,
    required this.plantName,
    required this.type,
    required this.imageName,
    required this.result,
    required this.disease,
    required this.affectionPercent,
    required this.date,
    this.recommendations = const [],
  });

  bool get isHealthy =>
      disease.isEmpty || disease.toLowerCase().contains('saludable');

  Map<String, dynamic> toMap() {
    return {
      'plantId': plantId,
      'plantName': plantName,
      'type': type.storageKey,
      'imageName': imageName,
      'result': result,
      'disease': disease,
      'affectionPercent': affectionPercent,
      'date': Timestamp.fromDate(date),
      'recommendations': recommendations,
    };
  }

  factory AnalysisDto.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return DateTime.now();
    }

    return AnalysisDto(
      plantId: (map['plantId'] ?? '') as String,
      plantName: (map['plantName'] ?? '') as String,
      type: AnalysisTypeLabel.fromString(map['type'] as String?),
      imageName: (map['imageName'] ?? '') as String,
      result: (map['result'] ?? '') as String,
      disease: (map['disease'] ?? '') as String,
      affectionPercent: (map['affectionPercent'] as num?)?.toDouble() ?? 0,
      date: parseDate(map['date']),
      recommendations: (map['recommendations'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}

class AnalysisEntry {
  final String id;
  final AnalysisDto dto;

  const AnalysisEntry({required this.id, required this.dto});
}
