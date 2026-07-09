import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModelReady<T extends ChangeNotifier> extends StatefulWidget {
  final Widget child;
  final Future<void> Function(T model) onModelReady;

  const ModelReady({
    Key? key, 
    required this.child,
    required this.onModelReady,
  }) : super(key: key);

  @override
  State<ModelReady<T>> createState() => _ModelReadyState<T>();
}

class _ModelReadyState<T extends ChangeNotifier>
    extends State<ModelReady<T>> {

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    final model = context.read<T>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onModelReady(model);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}