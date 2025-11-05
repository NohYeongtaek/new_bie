import 'package:flutter/material.dart';

class CircularProgressIndicatorUi extends StatelessWidget {
  const CircularProgressIndicatorUi({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget loadingProgress = Center(
      child: CircularProgressIndicator(strokeCap: StrokeCap.round),
    );
    return loadingProgress;
  }
}
