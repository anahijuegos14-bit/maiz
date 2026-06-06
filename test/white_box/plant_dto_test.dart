import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app/features/plants/model/plant_dto.dart';

void main() {
  group('PlantDto (caja blanca)', () {
    final planted = DateTime(2024, 3, 10);
    final watered = DateTime(2024, 5, 1);
    final older = DateTime(2024, 4, 1);

    test('copyWith conserva campos no reemplazados', () {
      final dto = PlantDto(
        name: 'Tomate',
        location: 'Invernadero',
        notes: 'Suelo fertil',
        plantedDate: planted,
        lastWateringDate: watered,
        wateringHistory: [watered],
      );

      final copy = dto.copyWith(name: 'Tomate cherry');

      expect(copy.name, 'Tomate cherry');
      expect(copy.location, 'Invernadero');
      expect(copy.notes, 'Suelo fertil');
    });

    test('toMap y fromMap son simétricos con Timestamp', () {
      final dto = PlantDto(
        name: 'Lechuga',
        location: 'Maceta',
        notes: '',
        plantedDate: planted,
        lastWateringDate: watered,
        wateringHistory: [watered, older],
      );

      final restored = PlantDto.fromMap(dto.toMap());

      expect(restored.name, dto.name);
      expect(restored.location, dto.location);
      expect(restored.plantedDate, dto.plantedDate);
      expect(restored.lastWateringDate, dto.lastWateringDate);
      expect(restored.wateringHistory.length, 2);
    });

    test('fromMap ordena wateringHistory descendente', () {
      final map = {
        'name': 'Maiz',
        'location': 'Campo',
        'notes': '',
        'plantedDate': Timestamp.fromDate(planted),
        'lastWateringDate': Timestamp.fromDate(watered),
        'wateringHistory': [
          Timestamp.fromDate(older),
          Timestamp.fromDate(watered),
        ],
      };

      final dto = PlantDto.fromMap(map);

      expect(dto.wateringHistory.first, watered);
      expect(dto.wateringHistory.last, older);
    });

    test('mergeWateringHistory inserta y ordena por fecha', () {
      final merged = PlantDto.mergeWateringHistory(
        current: [older],
        wateringDate: watered,
      );

      expect(merged.first, watered);
      expect(merged.last, older);
    });

    test('fromMap usa valores por defecto ante datos incompletos', () {
      final dto = PlantDto.fromMap({});

      expect(dto.name, '');
      expect(dto.location, '');
      expect(dto.wateringHistory, isEmpty);
    });
  });
}
