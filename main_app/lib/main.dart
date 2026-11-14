import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/di/injection.dart';
import 'presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final (deps, _) = await (
    AppDependencies.create(),
    initializeDateFormatting(),
  ).wait;
  runApp(KidGuardApp(deps: deps));
  await deps.guardController.init();
}
