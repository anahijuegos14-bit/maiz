import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../plants/manager/plants_manager.dart';
import '../../plants/model/plant_dto.dart';
import '../../plants/model/plant_status.dart';
import '../model/analysis_dto.dart';
import '../services/analysis_data_source.dart';
import '../services/analysis_engine.dart';

class AnalysisRunRequest {
  final String plantId;
  final AnalysisType type;
  final XFile image;

  const AnalysisRunRequest({
    required this.plantId,
    required this.type,
    required this.image,
  });
}

class AnalysisManager {
  AnalysisManager({
    required String userId,
    required AnalysisDataSource service,
    required PlantsManager plantsManager,
  })  : _userId = userId,
        _service = service,
        _plantsManager = plantsManager;

  final String _userId;
  final AnalysisDataSource _service;
  final PlantsManager _plantsManager;

  final analyses = ValueNotifier<List<AnalysisEntry>>([]);

  StreamSubscription<List<AnalysisEntry>>? _subscription;

  late final runAnalysisCommand = Command.createAsync<AnalysisRunRequest, String>(
    (request) async {
      final plantEntry = _plantsManager.plants.value
          .firstWhere((entry) => entry.id == request.plantId);
      final result = AnalysisEngine.analyze(
        type: request.type,
        imageName: request.image.name,
      );
      final dto = AnalysisDto(
        plantId: request.plantId,
        plantName: plantEntry.dto.name,
        type: request.type,
        imageName: request.image.name,
        result: result.summary,
        disease: result.disease,
        affectionPercent: result.affectionPercent,
        date: DateTime.now(),
        recommendations: result.recommendations,
      );
      final id = await _service.create(_userId, dto);

      if (!result.isHealthy) {
        final newStatus = result.affectionPercent >= 60
            ? PlantStatus.critico
            : result.affectionPercent >= 30
                ? PlantStatus.enfermo
                : PlantStatus.enObservacion;
        _plantsManager.savePlantCommand.run(
          PlantSaveRequest(
            id: request.plantId,
            dto: plantEntry.dto.copyWith(status: newStatus),
          ),
        );
      }

      return id;
    },
    initialValue: '',
  );

  Future<AnalysisManager> init() async {
    _subscription = _service.watchAnalyses(_userId).listen((entries) {
      analyses.value = entries;
    });
    return this;
  }

  void dispose() {
    _subscription?.cancel();
    analyses.dispose();
  }
}
