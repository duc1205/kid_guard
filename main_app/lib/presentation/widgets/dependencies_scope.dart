import 'package:flutter/widgets.dart';

import '../../core/di/injection.dart';

class DependenciesScope extends InheritedWidget {
  const DependenciesScope({
    super.key,
    required this.deps,
    required super.child,
  });

  final AppDependencies deps;

  static AppDependencies of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<DependenciesScope>()!.deps;

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) =>
      deps != oldWidget.deps;
}
