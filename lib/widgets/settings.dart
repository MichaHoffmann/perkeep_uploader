import 'package:flutter/material.dart';
import 'package:perkeep_uploader/widgets/hack/global.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  _SettingsViewState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          )),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Connection'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: const Text('Host and Port'),
                leading: const Icon(Icons.link),
                value: const Text("0.0.0.0:3184"),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Behavior'),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                title: const Text('Enable Uploads'),
                leading: const Icon(Icons.upload),
                initialValue: false,
                onToggle: (value) {
                  settings.setDoUploads(value);
                },
              ),
              SettingsTile.switchTile(
                title: const Text('Enable Watching'),
                leading: const Icon(Icons.search),
                initialValue: false,
                onToggle: (value) {
                  settings.setDoWatch(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
