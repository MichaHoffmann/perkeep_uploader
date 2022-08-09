import 'dart:async';
import 'dart:developer' as developer;

import 'package:perkeep_uploader/logic/uploader.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoManagerUploaderWatcher implements UploaderWatcher {
  final StreamController<UploadFile> controller = StreamController();

  @override
  Stream<UploadFile> stream() {
    PhotoManager.addChangeCallback((value) {
      developer.log("Saw change $value", name: "org.perkeep.UploadFileWatcher");
      addAssetFromId("${value.arguments['id']}");
    });

    return controller.stream;
  }

  @override
  void start() {
    PhotoManager.startChangeNotify();
  }

  @override
  void stop() {
    PhotoManager.stopChangeNotify();
  }

  void addAssetFromId(String id) async {
    Future.sync(() => null);
    var asset = await AssetEntity.fromId(id);
    if (asset == null) {
      developer.log("unable to load asset from id: $id",
          name: "org.perkeep.UploadFileWatcher");
      return;
    }
    if (!await asset.exists) {
      developer.log("asset with id did not exist: $id",
          name: "org.perkeep.UploadFileWatcher");
      return;
    }
    var file = await asset.loadFile();
    if (file == null) {
      developer.log("unable to load file from asset with id: $id",
          name: "org.perkeep.UploadFileWatcher");
      return;
    }
    developer.log("added file: $id, ${file.path}",
        name: "org.perkeep.UploadFileWatcher");
    controller.add(UploadFile(file: file));
  }
}
