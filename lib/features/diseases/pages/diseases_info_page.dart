import 'package:flutter/material.dart';

class CornDisease {
  final String name;
  final String category;
  final String description;
  final String symptoms;
  final String treatment;
  final String prevention;
  final IconData icon;
  final Color color;

  const CornDisease({
    required this.name,
    required this.category,
    required this.description,
    required this.symptoms,
    required this.treatment,
    required this.prevention,
    required this.icon,
    required this.color,
  });
}

const _diseases = [
  CornDisease(
    name: 'Roya del maíz',
    category: 'Fúngica',
    description:
        'Ataca principalmente el follaje y reduce la fotosíntesis cuando avanza sin control.',
    symptoms:
        'Pústulas pequeñas de color naranja, marrón o castaño en hojas. En casos severos aparecen en tallos y hojas internas.',
    treatment:
        'Aplicar fungicidas con triazoles o estrobilurinas al detectar los primeros síntomas. Repetir monitoreo en 5 a 7 días.',
    prevention:
        'Usar variedades resistentes, retirar residuos infectados y evitar humedad prolongada sobre las hojas.',
    icon: Icons.coronavirus_rounded,
    color: Color(0xFFD84315),
  ),
  CornDisease(
    name: 'Mancha gris',
    category: 'Fúngica',
    description:
        'Frecuente en climas cálidos y húmedos; puede causar defoliación prematura.',
    symptoms:
        'Lesiones rectangulares gris claro a marrón, delimitadas por nervaduras y visibles en hojas medias e inferiores.',
    treatment:
        'Aplicar fungicida preventivo cuando hay alta humedad y avance de lesiones en hojas superiores.',
    prevention:
        'Rotar cultivos, incorporar residuos y elegir híbridos tolerantes en zonas con historial de la enfermedad.',
    icon: Icons.grain_rounded,
    color: Color(0xFF5D6D7E),
  ),
  CornDisease(
    name: 'Tizón foliar',
    category: 'Fúngica',
    description:
        'Produce necrosis alargada en hojas y puede afectar calidad y llenado del grano.',
    symptoms:
        'Manchas ovaladas o alargadas con centro claro y borde oscuro. En etapas avanzadas la hoja se seca.',
    treatment:
        'Mejorar drenaje y aplicar fungicida en etapa vegetativa si el clima favorece la infección.',
    prevention:
        'Evitar densidad excesiva, seleccionar semilla sana y mantener buena ventilación del cultivo.',
    icon: Icons.sick_rounded,
    color: Color(0xFF8E44AD),
  ),
  CornDisease(
    name: 'Mancha de asfalto',
    category: 'Fúngica',
    description:
        'Genera lesiones negras brillantes y se intensifica en ambientes tropicales húmedos.',
    symptoms:
        'Puntos negros circulares u ovalados de 2 a 10 mm, con apariencia de asfalto sobre la hoja.',
    treatment:
        'Monitorear brotes tempranos, eliminar plantas muy afectadas y usar fungicidas en focos activos.',
    prevention:
        'Sembrar variedades tolerantes, reducir rastrojos infectados y revisar lotes después de lluvias constantes.',
    icon: Icons.circle_rounded,
    color: Color(0xFF263238),
  ),
  CornDisease(
    name: 'Helmintosporiosis',
    category: 'Fúngica',
    description:
        'También conocida como tizón del norte; avanza desde hojas inferiores hacia superiores.',
    symptoms:
        'Lesiones elípticas gris verdosas a marrón, con bordes oscuros y crecimiento progresivo.',
    treatment:
        'Aplicar fungicidas foliares cuando las lesiones aparecen antes de floración o suben rápidamente.',
    prevention:
        'Rotar con no hospederos, usar híbridos resistentes y evitar exceso de humedad en el lote.',
    icon: Icons.water_drop_rounded,
    color: Color(0xFF0277BD),
  ),
  CornDisease(
    name: 'Fusarium en mazorca',
    category: 'Hongo de grano',
    description:
        'Afecta mazorcas y tallos; puede producir micotoxinas que reducen calidad del grano.',
    symptoms:
        'Granos arrugados o rosados, espigas blanqueadas y tallos debilitados con daño interno.',
    treatment:
        'Separar mazorcas afectadas, secar bien el grano y consultar manejo químico si el problema es recurrente.',
    prevention:
        'Evitar estrés hídrico, controlar daño de insectos y cosechar oportunamente con buen secado posterior.',
    icon: Icons.warning_amber_rounded,
    color: Color(0xFFF9A825),
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
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: colors.primary,
                  size: 34,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Biblioteca de enfermedades del maíz',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Consulta síntomas, tratamientos y prevención para cuidar tu cosecha.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _InfoChip(icon: Icons.eco_rounded, label: 'Follaje'),
            _InfoChip(icon: Icons.water_drop_rounded, label: 'Humedad'),
            _InfoChip(icon: Icons.agriculture_rounded, label: 'Manejo'),
            _InfoChip(icon: Icons.health_and_safety_rounded, label: 'Prevención'),
          ],
        ),
        const SizedBox(height: 18),
        ..._diseases.map(
          (disease) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _DiseaseCard(disease: disease),
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(icon, size: 18, color: colors.primary),
      label: Text(label),
      backgroundColor: Colors.white,
      side: BorderSide(color: colors.outlineVariant),
    );
  }
}

class _DiseaseCard extends StatelessWidget {
  final CornDisease disease;

  const _DiseaseCard({required this.disease});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: disease.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(disease.icon, color: disease.color, size: 27),
          ),
          title: Text(
            disease.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _SmallTag(
                      label: disease.category,
                      color: disease.color,
                    ),
                    _SmallTag(
                      label: 'Maíz',
                      color: colors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  disease.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          children: [
            _DiseaseSection(
              icon: Icons.search_rounded,
              title: 'Síntomas',
              text: disease.symptoms,
              color: disease.color,
            ),
            _DiseaseSection(
              icon: Icons.medication_rounded,
              title: 'Tratamiento',
              text: disease.treatment,
              color: colors.primary,
            ),
            _DiseaseSection(
              icon: Icons.shield_rounded,
              title: 'Prevención',
              text: disease.prevention,
              color: colors.tertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallTag extends StatelessWidget {
  final String label;
  final Color color;

  const _SmallTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _DiseaseSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final Color color;

  const _DiseaseSection({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 3),
                Text(text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
