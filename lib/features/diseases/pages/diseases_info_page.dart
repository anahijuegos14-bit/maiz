import 'package:flutter/material.dart';

class CornDisease {
  final String name;
  final String description;
  final String symptoms;
  final String treatment;
  final IconData icon;

  const CornDisease({
    required this.name,
    required this.description,
    required this.symptoms,
    required this.treatment,
    required this.icon,
  });
}

const _diseases = [
  CornDisease(
    name: 'Roya del maíz (Puccinia sorghi)',
    description:
        'Enfermedad fúngica que afecta el follaje del maíz, reduciendo '
        'la fotosíntesis y el rendimiento del cultivo.',
    symptoms:
        'Pústulas pequeñas de color naranja, marrón o castaño en la '
        'superficie superior de las hojas. En casos severos aparecen '
        'en tallos y hojas internas.',
    treatment:
        'Aplicar fungicidas a base de triazoles o estrobilurinas al '
        'detectar los primeros síntomas. Eliminar restos de cultivo '
        'infectados y usar variedades resistentes.',
    icon: Icons.coronavirus_rounded,
  ),
  CornDisease(
    name: 'Mancha gris (Cercospora zeae-maydis)',
    description:
        'Una de las enfermedades foliares más comunes del maíz en '
        'climas cálidos y húmedos.',
    symptoms:
        'Lesiones rectangulares de color gris pálido a marrón, '
        'delimitadas por las nervaduras. Puede causar defoliación '
        'prematura.',
    treatment:
        'Rotación de cultivos, labranza que incorpore residuos y '
        'aplicación preventiva de fungicidas en condiciones de alta '
        'humedad.',
    icon: Icons.grain_rounded,
  ),
  CornDisease(
    name: 'Tizón foliar del maíz',
    description:
        'Grupo de enfermedades que causan necrosis en hojas y mazorcas, '
        'afectando la calidad del grano.',
    symptoms:
        'Manchas ovaladas o alargadas con bordes oscuros y centro '
        'claro. En etapas avanzadas las hojas se secan completamente.',
    treatment:
        'Mejorar drenaje, evitar densidades excesivas de siembra y '
        'aplicar fungicidas en pre-tassel si el clima es favorable '
        'para la enfermedad.',
    icon: Icons.sick_rounded,
  ),
  CornDisease(
    name: 'Mancha de asfalto (Phyllachora maydis)',
    description:
        'Enfermedad fúngica que produce lesiones negras en hojas, '
        'común en zonas tropicales y subtropicales.',
    symptoms:
        'Manchas circulares u ovaladas negras y brillantes, como '
        'asfalto, de 2 a 10 mm de diámetro en hojas.',
    treatment:
        'Monitoreo temprano, eliminación de plantas muy afectadas y '
        'uso de variedades tolerantes. Fungicidas en brotes activos.',
    icon: Icons.circle_rounded,
  ),
  CornDisease(
    name: 'Helmintosporiosis (Exserohilum turcicum)',
    description:
        'Tizón del norte que afecta maíz en regiones con rocío '
        'abundante y temperaturas moderadas.',
    symptoms:
        'Lesiones elípticas de color gris verdoso a marrón con '
        'bordes oscuros. Comienza en hojas inferiores y asciende.',
    treatment:
        'Híbridos resistentes, rotación con no hospederos y '
        'fungicidas foliares en etapa vegetativa temprana.',
    icon: Icons.water_drop_rounded,
  ),
  CornDisease(
    name: 'Giberela del maíz (Fusarium)',
    description:
        'Afecta espigas y tallos, produciendo mazorcas deformes y '
        'micotoxinas que reducen la calidad del grano.',
    symptoms:
        'Espigas blanqueadas o rosadas, granos arrugados y tallos '
        'con canker interno. Puede aparecer tras sequía o granizo.',
    treatment:
        'Evitar estrés hídrico, aplicar fungicidas en floración y '
        'secar el grano correctamente post-cosecha.',
    icon: Icons.warning_amber_rounded,
  ),
];

class DiseasesInfoPage extends StatelessWidget {
  const DiseasesInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        Text(
          'Biblioteca de enfermedades del maíz',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Conoce las enfermedades más comunes del maíz, sus síntomas '
          'y tratamientos recomendados para proteger tu cosecha.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 20),
        ..._diseases.map(
          (disease) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: colors.primaryContainer,
                  child: Icon(disease.icon, color: colors.primary, size: 22),
                ),
                title: Text(
                  disease.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  disease.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Síntomas',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(disease.symptoms),
                        const SizedBox(height: 12),
                        Text(
                          'Tratamiento',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(disease.treatment),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
