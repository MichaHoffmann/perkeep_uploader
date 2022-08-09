import 'dart:async';

import 'package:perkeep_uploader/logic/uploader.dart';

// TODO: use sqlite here, check for duplicate items, requeue failed items, etc.
class MemoryUploaderQueue implements UploaderQueue {
  final StreamController<UploadFile> controller = StreamController();

  @override
  void enqueue(UploadFile uploadFile) {
    controller.add(uploadFile);
  }

  @override
  Stream<UploadFile> stream() {
    return controller.stream;
  }
}
