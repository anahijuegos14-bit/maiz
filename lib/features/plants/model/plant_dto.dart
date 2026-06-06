import 'package:cloud_firestore/cloud_firestore.dart';

import 'plant_status.dart';

class PlantDto {
  final String name;
  final String variety;
  final String location;
  final String placeName;
  final String notes;
  final double areaHectares;
  final double? latitude;
  final double? longitude;
  final PlantStatus status;
  final DateTime plantedDate;
  final DateTime lastWateringDate;
  final List<DateTime> wateringHistory;

  const PlantDto({
    required this.name,
    this.variety = '',
    required this.location,
    this.placeName = '',
    required this.notes,
    this.areaHectares = 0,
    this.latitude,
    this.longitude,
    this.status = PlantStatus.saludable,
    required this.plantedDate,
    required this.lastWateringDate,
    required this.wateringHistory,
  });

  String get displayLocation =>
      placeName.isNotEmpty ? placeName : location;

  static List<DateTime> mergeWateringHistory({
    required List<DateTime> current,
    required DateTime wateringDate,
  }) {
    final history = List<DateTime>.from(current)..insert(0, wateringDate);
    history.sort((a, b) => b.compareTo(a));
    return history;
  }

  PlantDto copyWith({
    String? name,
    String? variety,
    String? location,
    String? placeName,
    String? notes,
    double? areaHectares,
    double? latitude,
    double? longitude,
    PlantStatus? status,
    DateTime? plantedDate,
    DateTime? lastWateringDate,
    List<DateTime>? wateringHistory,
  }) {
    return PlantDto(
      name: name ?? this.name,
      variety: variety ?? this.variety,
      location: location ?? this.location,
      placeName: placeName ?? this.placeName,
      notes: notes ?? this.notes,
      areaHectares: areaHectares ?? this.areaHectares,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      plantedDate: plantedDate ?? this.plantedDate,
      lastWateringDate: lastWateringDate ?? this.lastWateringDate,
      wateringHistory: wateringHistory ?? this.wateringHistory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'variety': variety,
      'location': location,
      'placeName': placeName,
      'notes': notes,
      'areaHectares': areaHectares,
      'latitude': latitude,
      'longitude': longitude,
      'status': status.storageKey,
      'plantedDate': Timestamp.fromDate(plantedDate),
      'lastWateringDate': Timestamp.fromDate(lastWateringDate),
      'wateringHistory': wateringHistory.map(Timestamp.fromDate).toList(),
    };
  }

  factory PlantDto.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return DateTime.now();
    }

    final historyRaw = (map['wateringHistory'] as List<dynamic>? ?? []);
    final history = historyRaw.map(parseDate).toList()
      ..sort((a, b) => b.compareTo(a));
    return PlantDto(
      name: (map['name'] ?? '') as String,
      variety: (map['variety'] ?? '') as String,
      location: (map['location'] ?? '') as String,
      placeName: (map['placeName'] ?? '') as String,
      notes: (map['notes'] ?? '') as String,
      areaHectares: (map['areaHectares'] as num?)?.toDouble() ?? 0,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      status: PlantStatus.fromString(map['status'] as String?),
      plantedDate: parseDate(map['plantedDate']),
      lastWateringDate: parseDate(map['lastWateringDate']),
      wateringHistory: history,
    );
  }
}

class PlantEntry {
  final String id;
  final PlantDto dto;

  const PlantEntry({required this.id, required this.dto});
}

class PlantSaveRequest {
  final String? id;
  final PlantDto dto;

  const PlantSaveRequest({this.id, required this.dto});
}

class WateringUpdateRequest {
  final String plantId;
  final PlantDto current;
  final DateTime wateringDate;

  const WateringUpdateRequest({
    required this.plantId,
    required this.current,
    required this.wateringDate,
  });
}
