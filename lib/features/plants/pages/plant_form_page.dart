import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/widgets/app_button.dart';
import '../../../_shared/widgets/app_text_field.dart';
import '../../../_shared/widgets/authenticated_shell.dart';
import '../manager/plants_manager.dart';
import '../model/plant_dto.dart';
import '../model/plant_status.dart';

class PlantFormPage extends WatchingStatefulWidget {
  final PlantDto? initialPlant;
  final String? plantId;

  const PlantFormPage({super.key, this.initialPlant, this.plantId});

  @override
  State<PlantFormPage> createState() => _PlantFormPageState();
}

class _PlantFormPageState extends State<PlantFormPage> {
  final _nameController = TextEditingController();
  final _varietyController = TextEditingController();
  final _placeController = TextEditingController();
  final _areaController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _plantedDate;
  bool _nameError = false;
  String? _areaError;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    final plant = widget.initialPlant;
    if (plant == null) {
      _plantedDate = DateTime.now();
      return;
    }
    _nameController.text = plant.name;
    _varietyController.text = plant.variety;
    _placeController.text = plant.placeName.isNotEmpty
        ? plant.placeName
        : plant.location;
    if (plant.areaHectares > 0) {
      _areaController.text = plant.areaHectares.toString();
    }
    if (plant.latitude != null) {
      _latController.text = plant.latitude!.toStringAsFixed(5);
    }
    if (plant.longitude != null) {
      _lngController.text = plant.longitude!.toStringAsFixed(5);
    }
    _notesController.text = plant.notes;
    _plantedDate = plant.plantedDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _varietyController.dispose();
    _placeController.dispose();
    _areaController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _locating = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permiso de ubicación denegado.')),
          );
        }
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _latController.text = position.latitude.toStringAsFixed(5);
        _lngController.text = position.longitude.toStringAsFixed(5);
      });
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  double? _parseArea() {
    final text = _areaController.text.trim();
    if (text.isEmpty) {
      setState(() => _areaError = 'Ingresa un área mayor a 0.');
      return null;
    }
    final value = double.tryParse(text.replaceAll(',', '.'));
    if (value == null || value <= 0) {
      setState(() => _areaError = 'Debe ser mayor a 0.');
      return null;
    }
    setState(() => _areaError = null);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = watchValue((PlantsManager m) => m.savePlantCommand.isRunning);
    final colors = Theme.of(context).colorScheme;
    final isEditing = widget.initialPlant != null;

    registerHandler(
      select: (PlantsManager m) => m.savePlantCommand.results,
      handler: (context, result, cancel) {
        if (result.hasData && result.data != null && result.data!.isNotEmpty) {
          Navigator.pop(context);
        }
      },
    );

    return AuthenticatedShell(
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Editar Planta' : 'Registrar Planta'),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      controller: _nameController,
                      label: 'Nombre *',
                    ),
                    if (_nameError)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'El nombre es obligatorio.',
                          style: TextStyle(color: colors.error),
                        ),
                      ),
                    const SizedBox(height: 10),
                    AppTextField(
                      controller: _varietyController,
                      label: 'Variedad (ej. Amarillo H-512)',
                    ),
                    const SizedBox(height: 10),
                    _DatePickerTile(
                      label: 'Fecha de Siembra',
                      value: _plantedDate,
                      onTap: () async {
                        final selected = await _pickDate(context, _plantedDate);
                        if (selected == null) return;
                        setState(() => _plantedDate = selected);
                      },
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      controller: _areaController,
                      label: 'Área (hectáreas, ej. 2.5)',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    if (_areaError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          _areaError!,
                          style: TextStyle(color: colors.error),
                        ),
                      ),
                    const SizedBox(height: 10),
                    AppTextField(
                      controller: _placeController,
                      label: 'Nombre del lugar (ej. Vereda San Pedro)',
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      onPressed: _locating ? null : _useCurrentLocation,
                      icon: _locating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location_rounded),
                      label: const Text('Usar mi ubicación actual'),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      controller: _latController,
                      label: 'Latitud (ej. 4.71100)',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      controller: _lngController,
                      label: 'Longitud (ej. -74.07210)',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      controller: _notesController,
                      label: 'Observaciones',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 14),
                    AppButton(
                      text: isSaving
                          ? 'Guardando...'
                          : isEditing
                              ? 'Guardar Cambios'
                              : 'Registrar Planta',
                      onPressed: isSaving ? null : _savePlant,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _pickDate(BuildContext context, DateTime? current) {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(2018),
      lastDate: DateTime(now.year + 2),
    );
  }

  void _savePlant() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = true);
      return;
    }
    if (_plantedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona la fecha de siembra.')),
      );
      return;
    }

    final parsedArea = _parseArea();
    if (parsedArea == null) return;
    final area = parsedArea;

    final lat = double.tryParse(_latController.text.trim());
    final lng = double.tryParse(_lngController.text.trim());
    final place = _placeController.text.trim();

    final existing = widget.initialPlant;
    final dto = PlantDto(
      name: name,
      variety: _varietyController.text.trim(),
      location: place,
      placeName: place,
      notes: _notesController.text.trim(),
      areaHectares: area,
      latitude: lat,
      longitude: lng,
      status: existing?.status ?? PlantStatus.saludable,
      plantedDate: _plantedDate!,
      lastWateringDate: existing?.lastWateringDate ?? _plantedDate!,
      wateringHistory: existing?.wateringHistory ?? [],
    );

    di<PlantsManager>().savePlantCommand.run(
          PlantSaveRequest(id: widget.plantId, dto: dto),
        );
  }
}

class _DatePickerTile extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  const _DatePickerTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.event_rounded),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value == null
                      ? label
                      : '$label: ${value!.day}/${value!.month}/${value!.year}',
                ),
              ),
              const Icon(Icons.calendar_month_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
