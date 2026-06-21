import 'package:flutter/material.dart';
import 'package:tvseries/app.dart';
import 'package:tvseries/di/injection.dart';

Future<void> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}
