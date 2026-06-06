import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/plant_dto.dart';
import 'plants_data_source.dart';

class PlantsFirestoreService implements PlantsDataSource {
  final FirebaseFirestore firestore;

  PlantsFirestoreService(this.firestore);

  CollectionReference<Map<String, dynamic>> _plantsRef(String userId) {
    return firestore.collection('users').doc(userId).collection('plants');
  }

  @override
  Stream<List<PlantEntry>> watchPlants(String userId) {
    return _plantsRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => PlantEntry(
                  id: doc.id,
                  dto: PlantDto.fromMap(doc.data()),
                ),
              )
              .toList(),
        );
  }

  @override
  Future<String> create(String userId, PlantDto plant) async {
    final doc = await _plantsRef(userId).add({
      ...plant.toMap(),
      'createdAt': Timestamp.now(),
    });
    return doc.id;
  }

  @override
  Future<void> update(String userId, String plantId, PlantDto plant) {
    return _plantsRef(userId).doc(plantId).update(plant.toMap());
  }

  @override
  Future<void> delete(String userId, String plantId) {
    return _plantsRef(userId).doc(plantId).delete();
  }

  @override
  Future<void> updateWatering(
    String userId,
    String plantId,
    PlantDto updated,
  ) {
    return _plantsRef(userId).doc(plantId).update(updated.toMap());
  }
}
