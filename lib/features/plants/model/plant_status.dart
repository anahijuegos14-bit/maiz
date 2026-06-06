enum PlantStatus {
  saludable,
  enObservacion,
  enfermo,
  critico;

  String get label {
    switch (this) {
      case PlantStatus.saludable:
        return 'Saludable';
      case PlantStatus.enObservacion:
        return 'En observación';
      case PlantStatus.enfermo:
        return 'Enfermo';
      case PlantStatus.critico:
        return 'Crítico';
    }
  }

  static PlantStatus fromString(String? value) {
    switch (value) {
      case 'enObservacion':
        return PlantStatus.enObservacion;
      case 'enfermo':
        return PlantStatus.enfermo;
      case 'critico':
        return PlantStatus.critico;
      default:
        return PlantStatus.saludable;
    }
  }

  String get storageKey {
    switch (this) {
      case PlantStatus.saludable:
        return 'saludable';
      case PlantStatus.enObservacion:
        return 'enObservacion';
      case PlantStatus.enfermo:
        return 'enfermo';
      case PlantStatus.critico:
        return 'critico';
    }
  }

  bool get isAtRisk =>
      this == PlantStatus.enObservacion ||
      this == PlantStatus.enfermo ||
      this == PlantStatus.critico;
}
