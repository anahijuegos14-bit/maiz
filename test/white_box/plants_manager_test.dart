import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app/features/auth/model/app_user.dart';
import 'package:mi_app/features/plants/manager/plants_manager.dart';
import 'package:mi_app/features/plants/model/plant_dto.dart';

import '../helpers/in_memory_plants_data_source.dart';

Future<void> _pumpCommand() async {
  await Future<void>.delayed(const Duration(milliseconds: 50));
}

void main() {
  group('PlantsManager (caja blanca)', () {
    late InMemoryPlantsDataSource dataSource;
    late PlantsManager manager;
    const user = AppUser(id: 'u1', email: 'a@test.com', name: 'Test');

    final samplePlant = PlantDto(
      name: 'Albahaca',
      location: 'Balcón',
      notes: '',
      plantedDate: DateTime(2024, 1, 1),
      lastWateringDate: DateTime(2024, 2, 1),
      wateringHistory: [DateTime(2024, 2, 1)],
    );

    setUp(() async {
      dataSource = InMemoryPlantsDataSource();
      manager = PlantsManager(user: user, service: dataSource);
      await manager.init();
    });

    tearDown(() {
      manager.dispose();
      dataSource.dispose();
    });

    test('savePlantCommand crea planta cuando id es null', () async {
      manager.savePlantCommand.run(PlantSaveRequest(dto: samplePlant));
      await _pumpCommand();

      expect(dataSource.lastCreatedUserId, 'u1');
      expect(dataSource.lastCreatedPlant?.name, 'Albahaca');
      expect(manager.savePlantCommand.value, isNotEmpty);
    });

    test('savePlantCommand actualiza cuando id existe', () async {
      final id = await dataSource.create('u1', samplePlant);
      final updated = samplePlant.copyWith(name: 'Albahaca morada');

      manager.savePlantCommand.run(PlantSaveRequest(id: id, dto: updated));
      await _pumpCommand();

      expect(dataSource.lastUpdatedPlantId, id);
      expect(dataSource.lastUpdatedPlant?.name, 'Albahaca morada');
    });

    test('updateWateringCommand fusiona historial y persiste', () async {
      final id = await dataSource.create('u1', samplePlant);
      final newWatering = DateTime(2024, 3, 15);

      manager.updateWateringCommand.run(
        WateringUpdateRequest(
          plantId: id,
          current: samplePlant,
          wateringDate: newWatering,
        ),
      );
      await _pumpCommand();

      final updated = dataSource.lastWateringUpdate!;
      expect(updated.lastWateringDate, newWatering);
      expect(updated.wateringHistory.first, newWatering);
      expect(updated.wateringHistory, contains(samplePlant.lastWateringDate));
    });

    test('deletePlantCommand elimina por id', () async {
      final id = await dataSource.create('u1', samplePlant);

      manager.deletePlantCommand.run(id);
      await _pumpCommand();

      expect(dataSource.lastDeletedPlantId, id);
      expect(manager.deletePlantCommand.value, isTrue);
    });

    test('watchPlants actualiza plants al crear', () async {
      expect(manager.plants.value, isEmpty);

      manager.savePlantCommand.run(PlantSaveRequest(dto: samplePlant));
      await _pumpCommand();

      expect(manager.plants.value, hasLength(1));
      expect(manager.plants.value.first.dto.name, 'Albahaca');
    });
  });
}
