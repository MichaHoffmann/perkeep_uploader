import 'dart:async';

import 'package:perkeep_uploader/logic/uploader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistentSettingsWatcher implements UploaderSettingsWatcher {
  StreamController<UploaderSettings> controller = StreamController();

  final String _hostPortKey = "uploader/host_port";
  final String _defaultHostPort = "0.0.0.0:3179";

  final String _authKey = "uploader/auth";
  final String _defaultAuth = "none";

  final String _doUploadsKey = "uploader/do_uploads";
  final bool _defaultDoUploads = false;

  final String _doWatchKey = "uploader/do_watch";
  final bool _defaultDoWatch = false;

  @override
  Stream<UploaderSettings> watch() {
    return controller.stream;
  }

  void setHostPort(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_hostPortKey, value);
    sendSettings();
  }

  void setAuth(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_authKey, value);
    sendSettings();
  }

  void setDoUploads(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_doUploadsKey, value);
    sendSettings();
  }

  void setDoWatch(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_doWatchKey, value);
    sendSettings();
  }

  void sendSettings() async {
    controller.add(await currentSettings());
  }

  Future<UploaderSettings> currentSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return UploaderSettings(
      prefs.getString(_hostPortKey) ?? _defaultHostPort,
      prefs.getString(_authKey) ?? _defaultAuth,
      prefs.getBool(_doUploadsKey) ?? _defaultDoUploads,
      prefs.getBool(_doWatchKey) ?? _defaultDoWatch,
    );
  }
}
