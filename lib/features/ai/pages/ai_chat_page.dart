import 'package:flutter/material.dart';

import '../../../_shared/widgets/eco_placeholder_card.dart';

class AIChatPage extends StatelessWidget {
  const AIChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        EcoPlaceholderCard(
          icon: Icons.smart_toy_rounded,
          title: 'Asistente IA',
          description:
              'Proximamente podras consultar dudas y obtener recomendaciones personalizadas.',
        ),
      ],
    );
  }
}
