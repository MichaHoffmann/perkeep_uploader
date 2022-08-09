import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:perkeep_uploader/widgets/settings.dart';
import 'package:perkeep_uploader/widgets/uploader.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  runApp(MaterialApp(
    title: 'Perkeep Uploader',
    theme: ThemeData(
      primarySwatch: Colors.yellow,
    ),
    initialRoute: '/uploader',
    routes: <String, WidgetBuilder>{
      '/uploader': (BuildContext _) => const UploadView(title: 'Uploader'),
      '/settings': (BuildContext _) => const SettingsView(title: 'Settings'),
    },
  ));
}
