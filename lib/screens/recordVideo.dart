import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:health_app/main.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class RecordVideo extends StatefulWidget {
  const RecordVideo({super.key});

  @override
  State<RecordVideo> createState() => _RecordVideoState();
}

String? path;

class _RecordVideoState extends State<RecordVideo> {
  CameraController? controller;
  Future<void>? initializeControllerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.high);

    initializeControllerFuture = controller!.initialize();
  }

  @override
  void dispose() {
    controller!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initializeControllerFuture,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: CameraPreview(controller!),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: !controller!.value.isRecordingVideo
                    ? RawMaterialButton(onPressed: () async {
                        try {
                          await initializeControllerFuture;

                          path = join(
                              (await getApplicationDocumentsDirectory()).path,
                              '${DateTime.now()}.mp4');

                          setState(() {
                            controller!.startVideoRecording();
                          });
                        } catch (e) {
                          print(e);
                        }
                      })
                    : null,
              )
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
