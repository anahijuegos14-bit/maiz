import '../model/plant_dto.dart';

abstract class PlantsDataSource {
  Stream<List<PlantEntry>> watchPlants(String userId);

  Future<String> create(String userId, PlantDto plant);

  Future<void> update(String userId, String plantId, PlantDto plant);

  Future<void> delete(String userId, String plantId);

  Future<void> updateWatering(
    String userId,
    String plantId,
    PlantDto updated,
  );
}
