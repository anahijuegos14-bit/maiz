import 'package:command_it/command_it.dart';

import 'package:flutter/foundation.dart';

import 'package:image_picker/image_picker.dart';

import 'package:watch_it/watch_it.dart';



import '../../../_shared/errors/exceptions.dart';

import '../../../_shared/services/interaction_manager.dart';

import '../../analysis/manager/analysis_manager.dart';

import '../../analysis/model/analysis_dto.dart';

import '../../plants/manager/plants_manager.dart';

import '../../plants/model/plant_dto.dart';

import '../services/camera_service.dart';



class CameraManager {

  CameraManager({

    required CameraService cameraService,

    required PlantsManager plantsManager,

    required AnalysisManager analysisManager,

  })  : _cameraService = cameraService,

        _plantsManager = plantsManager,

        _analysisManager = analysisManager;



  final CameraService _cameraService;

  final PlantsManager _plantsManager;

  final AnalysisManager _analysisManager;



  final selectedPlantId = ValueNotifier<String?>(null);

  final capturedImage = ValueNotifier<XFile?>(null);

  final analysisType = ValueNotifier<AnalysisType>(AnalysisType.hoja);



  ValueListenable<List<PlantEntry>> get plants => _plantsManager.plants;



  late final pickFromCameraCommand = Command.createAsyncNoParamNoResult(

    () async {

      final image = await _cameraService.pickFromCamera();

      if (image != null) capturedImage.value = image;

    },

  );



  late final pickFromGalleryCommand = Command.createAsyncNoParamNoResult(

    () async {

      final image = await _cameraService.pickFromGallery();

      if (image != null) capturedImage.value = image;

    },

  );



  late final analyzeCommand = Command.createAsyncNoParamNoResult(

    () async {

      if (capturedImage.value == null || selectedPlantId.value == null) {

        throw ServerException('Selecciona una planta y sube una imagen.');

      }

      _analysisManager.runAnalysisCommand.run(
        AnalysisRunRequest(
          plantId: selectedPlantId.value!,
          type: analysisType.value,
          image: capturedImage.value!,
        ),
      );

      di<InteractionManager>().showSnackBar(

        'Imagen cargada correctamente. El análisis comenzará en unos segundos.',

      );

      capturedImage.value = null;

    },

  );



  void selectPlant(String? plantId) => selectedPlantId.value = plantId;



  void setAnalysisType(AnalysisType type) => analysisType.value = type;



  void reset() {

    capturedImage.value = null;

    selectedPlantId.value = null;

    analysisType.value = AnalysisType.hoja;

  }

}


