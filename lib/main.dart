import 'dart:io';

import 'package:astro_life/screens/auth/login_screen.dart';
import 'package:astro_life/screens/home/home_screen.dart';
import 'package:astro_life/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sweph/sweph.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get a writable directory path for the app
  final appDocumentDir = await getApplicationDocumentsDirectory();
  final epheFilesPath = '${appDocumentDir.path}/ephe_files';

  // Ensure the directory exists
  final epheFilesDir = Directory(epheFilesPath);
  if (!await epheFilesDir.exists()) {
    await epheFilesDir.create(recursive: true);
  }

  // Initialize the sweph package with a writable path
  await Sweph.init(epheFilesPath: epheFilesPath, epheAssets: []);

  runApp(const AstroLifeApp());
}

class AstroLifeApp extends StatelessWidget {
  const AstroLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Astro Life',
      theme: appTheme,
      home: LoginScreen(),
    );
  }
}
