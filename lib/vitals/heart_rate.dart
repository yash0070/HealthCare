import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_app/auth/login.dart';
import 'package:health_app/screens/chart.dart';
import 'package:health_app/vitals/heart_rate_result.dart';
import 'package:wakelock/wakelock.dart';

class Heart extends StatefulWidget {
  const Heart({super.key});

  @override
  State<Heart> createState() => _HeartState();
}

class _HeartState extends State<Heart> with SingleTickerProviderStateMixin {
  bool _toggled = false;

  List<SensorValue> _data = <SensorValue>[];

  CameraController? _controller;

  int _bpm = 0;

  int _fs = 30;
  int _windowLen = 30 * 6;
  CameraImage? _image;
  double? _avg;
  DateTime? _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _toggled = false;
    _disposeController();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: <Widget>[
                      _controller != null && _toggled
                          ? AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: CameraPreview(_controller!),
                            )
                          : Container(
                              padding: EdgeInsets.all(12),
                              alignment: Alignment.center,
                              color: Colors.grey,
                            ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(4),
                        child: Text(
                          _toggled
                              ? "Cover both the camera and the flash with your finger"
                              : "Camera feed will display here",
                          style: TextStyle(
                              backgroundColor:
                                  _toggled ? Colors.white : Colors.transparent),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon:
                        Icon(_toggled ? Icons.favorite : Icons.favorite_border),
                    color: Colors.red,
                    iconSize: 128,
                    onPressed: () {
                      _toggle();
                      // if (_toggled) {
                      //   _untoggle();
                      // } else {
                      //   _toggle();
                      // }
                    },
                  ),
                ),
                // Expanded(
                //   flex: 1,
                //   child: Center(
                //       child: Column(
                //     mainAxisSize: MainAxisSize.min,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: <Widget>[
                //       Text(
                //         "Estimated BPM",
                //         style: TextStyle(fontSize: 18, color: Colors.grey),
                //       ),
                //       Text(
                //         (_bpm > 30 && _bpm < 150 ? _bpm.toString() : "--"),
                //         style: TextStyle(
                //             fontSize: 32, fontWeight: FontWeight.bold),
                //       ),
                //     ],
                //   )),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onPause() {
    _controller!.dispose();
    // _controller!.stopImageStream();
    _updateBPM();
  }

  void _clearData() {
    _data.clear();
    int now = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < _windowLen; i++)
      _data.insert(
          0,
          SensorValue(
              DateTime.fromMillisecondsSinceEpoch(now - i * 1000 ~/ _fs), 128));
  }

  Future<void> timer() async {
    try {
      await Future.delayed(Duration(seconds: 30), () {
        _controller!.setFlashMode(FlashMode.off);
        log('function called.........!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResultPage(
                      BpmResult: _bpm,
                    )));
      });
    } catch (e) {}
  }

  void afterTime() async {
    _controller!.dispose();
    _disposeController();
  }

  void _toggle() {
    _clearData();

    _initController().then((onValue) {
      timer();
      Wakelock.enable();
      startVideoRecording();

      setState(() {
        _toggled = true;
      });

      _initTimer();
      _updateBPM();
    });
  }

  void _untoggle() {
    _clearData();
    _disposeController();

    setState(() {
      _toggled = false;
    });
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  Future<void> _initController() async {
    try {
      List _cameras = await availableCameras();
      _controller = CameraController(_cameras.first, ResolutionPreset.low);
      await _controller!.initialize();
      Future.delayed(Duration(milliseconds: 100)).then((onValue) {
        _controller!.setFlashMode(FlashMode.torch);
      });
      _controller!.startImageStream((CameraImage image) {
        _image = image;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      Fluttertoast.showToast(msg: 'Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      return;
    }
  }

  //////

  void _initTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000 ~/ _fs), (timer) {
      if (_toggled) {
        if (_image != null) _scanImage(_image!);
      } else {
        timer.cancel();
      }
    });
  }

  void _scanImage(CameraImage image) {
    _now = DateTime.now();
    _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;
    if (_data.length >= _windowLen) {
      _data.removeAt(0);
    }
    setState(() {
      _data.add(SensorValue(_now!, 255 - _avg!));
    });
  }

  void _updateBPM() async {
    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _threshold;
    double _bpm;
    int _counter;
    int _previous;
    while (_toggled) {
      _values = List.from(_data);
      _avg = 0;
      _n = _values.length;
      _m = 0;
      _values.forEach((SensorValue value) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      });
      _threshold = (_m + _avg) / 2;
      _bpm = 0;
      _counter = 0;
      _previous = 0;
      for (int i = 1; i < _n; i++) {
        if (_values[i - 1].value < _threshold &&
            _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            _bpm += 60 *
                1000 /
                (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }
      if (_counter > 0) {
        double _alpha = 0.3;
        _bpm = _bpm / _counter;
        print(_bpm);
        setState(() {
          this._bpm = ((1 - _alpha) * this._bpm + _alpha * _bpm).toInt();
        });
      }
      await Future.delayed(Duration(
          milliseconds:
              1000 * _windowLen ~/ _fs)); // wait for a new set of _data values
    }
  }
}
