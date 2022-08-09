import 'package:perkeep_uploader/logic/queue.dart';
import 'package:perkeep_uploader/logic/settings.dart';
import 'package:perkeep_uploader/logic/uploader.dart';
import 'package:perkeep_uploader/logic/watcher.dart';

final PersistentSettingsWatcher settings = PersistentSettingsWatcher();
final UploadService uploadService = UploadService(
  queue: MemoryUploaderQueue(),
  watcher: PhotoManagerUploaderWatcher(),
  client: UploaderClient(),
  settings: settings,
);
