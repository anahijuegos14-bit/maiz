import 'dart:async';

import 'package:mi_app/features/plants/model/plant_dto.dart';
import 'package:mi_app/features/plants/services/plants_data_source.dart';

class InMemoryPlantsDataSource implements PlantsDataSource {
  final _controller = StreamController<List<PlantEntry>>.broadcast();
  final Map<String, Map<String, PlantDto>> _store = {};

  String? lastCreatedUserId;
  PlantDto? lastCreatedPlant;
  String? lastUpdatedPlantId;
  PlantDto? lastUpdatedPlant;
  String? lastDeletedPlantId;
  PlantDto? lastWateringUpdate;

  @override
  Stream<List<PlantEntry>> watchPlants(String userId) async* {
    yield _entriesFor(userId);
    await for (final _ in _controller.stream) {
      yield _entriesFor(userId);
    }
  }

  List<PlantEntry> _entriesFor(String userId) {
    final plants = _store[userId] ?? {};
    return plants.entries
        .map((e) => PlantEntry(id: e.key, dto: e.value))
        .toList();
  }

  void _emit(String userId) {
    if (!_controller.isClosed) {
      _controller.add(_entriesFor(userId));
    }
  }

  @override
  Future<String> create(String userId, PlantDto plant) async {
    lastCreatedUserId = userId;
    lastCreatedPlant = plant;
    final id = 'plant-${(_store[userId]?.length ?? 0) + 1}';
    _store.putIfAbsent(userId, () => {})[id] = plant;
    _emit(userId);
    return id;
  }

  @override
  Future<void> update(String userId, String plantId, PlantDto plant) async {
    lastUpdatedPlantId = plantId;
    lastUpdatedPlant = plant;
    _store.putIfAbsent(userId, () => {})[plantId] = plant;
    _emit(userId);
  }

  @override
  Future<void> delete(String userId, String plantId) async {
    lastDeletedPlantId = plantId;
    _store[userId]?.remove(plantId);
    _emit(userId);
  }

  @override
  Future<void> updateWatering(
    String userId,
    String plantId,
    PlantDto updated,
  ) async {
    lastWateringUpdate = updated;
    _store.putIfAbsent(userId, () => {})[plantId] = updated;
    _emit(userId);
  }

  void dispose() {
    _controller.close();
  }
}
