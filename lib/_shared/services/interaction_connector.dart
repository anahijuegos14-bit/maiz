import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'interaction_manager.dart';

class InteractionConnector extends StatefulWidget {
  const InteractionConnector({super.key, required this.child});

  final Widget child;

  @override
  State<InteractionConnector> createState() => _InteractionConnectorState();
}

class _InteractionConnectorState extends State<InteractionConnector> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    di<InteractionManager>().setContext(context);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
