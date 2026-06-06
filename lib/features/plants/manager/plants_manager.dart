import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:flutter/foundation.dart';

import '../../auth/model/app_user.dart';
import '../model/plant_dto.dart';
import '../services/plants_data_source.dart';

class PlantsManager {
  PlantsManager({
    required AppUser user,
    required PlantsDataSource service,
  })  : _user = user,
        _service = service;

  final AppUser _user;
  final PlantsDataSource _service;

  final plants = ValueNotifier<List<PlantEntry>>([]);

  StreamSubscription<List<PlantEntry>>? _subscription;

  late final savePlantCommand = Command.createAsync<PlantSaveRequest, String>(
    (request) async {
      if (request.id == null) {
        return _service.create(_user.id, request.dto);
      }
      await _service.update(_user.id, request.id!, request.dto);
      return request.id!;
    },
    initialValue: '',
  );

  late final deletePlantCommand = Command.createAsync<String, bool>(
    (plantId) async {
      await _service.delete(_user.id, plantId);
      return true;
    },
    initialValue: false,
  );

  late final updateWateringCommand =
      Command.createAsync<WateringUpdateRequest, bool>(
    (request) async {
      final history = PlantDto.mergeWateringHistory(
        current: request.current.wateringHistory,
        wateringDate: request.wateringDate,
      );
      final updated = request.current.copyWith(
        lastWateringDate: request.wateringDate,
        wateringHistory: history,
      );
      await _service.updateWatering(_user.id, request.plantId, updated);
      return true;
    },
    initialValue: false,
  );

  Future<PlantsManager> init() async {
    _subscription = _service.watchPlants(_user.id).listen((entries) {
      plants.value = entries;
    });
    return this;
  }

  void dispose() {
    _subscription?.cancel();
    plants.dispose();
  }
}
