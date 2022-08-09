import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UploadFile {
  final File file;

  const UploadFile({
    required this.file,
  });
}

class UploaderQueue {
  void enqueue(UploadFile uploadFile) => {};

  Stream<UploadFile> stream() => const Stream.empty();
}

class UploaderWatcher {
  void start() => {};
  void stop() => {};

  Stream<UploadFile> stream() => const Stream.empty();
}

class UploaderClient {
  bool ping() => false;
  void upload(File f) => {};
}

// TODO: allow to configure upload preferences like "on wifi" and "on battery"
class UploaderSettings {
  final String _hostport;
  final String _auth;

  final bool _doUploads;
  final bool _doWatch;

  UploaderSettings(
    this._hostport,
    this._auth,
    this._doUploads,
    this._doWatch,
  );

  String hostport() => _hostport;
  String auth() => _auth;
  bool doUploads() => _doUploads;
  bool doWatch() => _doWatch;

  @override
  String toString() {
    return "UploaderSettings['hostport': $_hostport, 'auth': $_auth, 'uploads enabled': $_doUploads, 'watch enabled': $_doWatch]";
  }
}

class UploaderSettingsWatcher {
  Stream<UploaderSettings> watch() => const Stream.empty();
}

enum UploaderServiceState {
  uploading,
  notUploading,
}

class UploadServiceInfo {
  UploaderServiceState state = UploaderServiceState.notUploading;
  int queuedFiles = 0;
  int queuedBytes = 0;
  int uploadedFiles = 0;
  int uploadedBytes = 0;
}

class UploadService with ChangeNotifier {
  UploaderQueue queue;
  UploaderWatcher watcher;
  UploaderClient client;
  UploaderSettingsWatcher settings;
  UploadServiceInfo info = UploadServiceInfo();

  StreamSubscription<UploadFile>? uploadQueuedFilesSubscription;

  UploadService({
    required this.queue,
    required this.watcher,
    required this.client,
    required this.settings,
  }) {
    developer.log("running uploader", name: "org.perkeep.Uploader");

    uploadQueuedFilesSubscription = uploadQueuedFiles();

    enqueueWatchedFiles();
    listenToSettings();
  }

  void listenToSettings() {
    settings.watch().forEach((config) {
      developer.log("got new config $config", name: "org.perkeep.Uploader");

      if (configAllowUploads(config)) {
        resumeUploading();
      } else {
        pauseUploading();
      }

      if (configAllowsWatching(config)) {
        resumeWatching();
      } else {
        pauseWatching();
      }
    });
  }

  bool configAllowUploads(UploaderSettings config) => config.doUploads();

  bool configAllowsWatching(UploaderSettings config) => config.doWatch();

  void pauseUploading() {
    uploadQueuedFilesSubscription?.pause();
    onStateChange(UploaderServiceState.notUploading);
  }

  void resumeUploading() {
    uploadQueuedFilesSubscription?.resume();
    onStateChange(UploaderServiceState.uploading);
  }

  void resumeWatching() => watcher.start();

  void pauseWatching() => watcher.stop();

  void enqueueFile(UploadFile uploadFile) {
    queue.enqueue(uploadFile);
    onEnqueuedFile(uploadFile);
  }

  void enqueueWatchedFiles() =>
      watcher.stream().forEach((uploadFile) => enqueueFile(uploadFile));

  void onEnqueuedFile(UploadFile file) {
    info.queuedFiles += 1;
    info.queuedBytes += file.file.lengthSync();
    notifyListeners();
  }

  void onDequeuedFile(UploadFile file) {
    info.queuedFiles -= 1;
    info.queuedBytes -= file.file.lengthSync();
    notifyListeners();
  }

  void onUploadedFile(UploadFile file) {
    info.uploadedFiles += 1;
    info.uploadedBytes += file.file.lengthSync();
    notifyListeners();
  }

  void onStateChange(UploaderServiceState state) {
    info.state = state;
    notifyListeners();
  }

  StreamSubscription<UploadFile> uploadQueuedFiles() {
    StreamSubscription<UploadFile> res = queue.stream().listen((uploadFile) {
      onDequeuedFile(uploadFile);
      handleUpload(uploadFile);
    });
    return res;
  }

  void handleUpload(UploadFile uploadFile) async {
    var file = uploadFile.file;
    developer.log("uploading ${file.path} of size ${file.lengthSync()}",
        name: "org.perkeep.Uploader");

    client.upload(file);
    onUploadedFile(uploadFile);
  }
}
