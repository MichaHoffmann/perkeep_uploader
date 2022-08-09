import 'package:flutter/material.dart';
import 'package:perkeep_uploader/logic/uploader.dart';
import 'package:perkeep_uploader/widgets/hack/global.dart';
import 'package:perkeep_uploader/widgets/util.dart';
import 'package:provider/provider.dart';

class UploadView extends StatelessWidget {
  const UploadView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UploadService>(
        create: (_) => uploadService,
        builder: (context, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text(title),
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    );
                  },
                ),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                      title: const Text("Uploader Status"),
                      trailing: Text(
                        formatUploadStatus(watchedState(context)),
                      )),
                  const Divider(),
                  ListTile(
                    title: const Text("Queued Files"),
                    trailing: Text("${watchedState(context).queuedFiles}"),
                  ),
                  ListTile(
                    title: const Text("Queued Bytes"),
                    trailing: Text(NumberFormatter.humanReadableBytes(
                        watchedState(context).queuedBytes)),
                  ),
                  ListTile(
                    title: const Text("Uploaded Files"),
                    trailing: Text("${watchedState(context).uploadedFiles}"),
                  ),
                  ListTile(
                      title: const Text("Uploaded Bytes"),
                      trailing: Text(
                        NumberFormatter.humanReadableBytes(
                            watchedState(context).uploadedBytes),
                      )),
                  LinearProgressIndicator(
                    value: getProgressEstimate(watchedState(context)),
                    minHeight: 10.0,
                  )
                ],
              ));
        });
  }

  UploadServiceInfo watchedState(BuildContext context) {
    return context.watch<UploadService>().info;
  }

  double getProgressEstimate(UploadServiceInfo info) {
    if (info.queuedBytes == 0) {
      return 1.0;
    }
    return info.uploadedBytes / info.queuedBytes;
  }

  String formatUploadStatus(UploadServiceInfo info) {
    if (info.queuedBytes == 0) {
      return "Idle";
    }
    switch (info.state) {
      case UploaderServiceState.uploading:
        return "Uploading";
      case UploaderServiceState.notUploading:
        return "Stopped";
    }
  }
}
