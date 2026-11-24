import 'package:flutter/material.dart';

import 'app/app.dart';
import 'services/favorites_service.dart';
import 'services/progress_service.dart';
import 'services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.instance.load();
  await ProgressService.instance.load();
  await FavoritesService.instance.load();
  runApp(const JqueryAjaxLabApp());
}
