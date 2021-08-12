import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:thumbnails/thumbnails.dart';

import 'Gallery.dart';
import 'VideoTimer.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  bool _isRecordingMode = false;
  bool _isRecording = false;
  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
  final _timerKey = GlobalKey<VideoTimerState>();

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.high);
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _captureImage() async {
    if (_controller!.value.isInitialized) {
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/media';
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/${_timestamp()}.jpeg';
      await _controller!.takePicture();
      setState(() {});
    }
  }

  Future<String?> startVideoRecording() async {
    print('startVideoRecording');
    if (!_controller!.value.isInitialized) {
      return null;
    }
    setState(() {
      _isRecording = true;
    });
    _timerKey.currentState?.startTimer();

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${_timestamp()}.mp4';

    if (_controller!.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      await _controller!.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> _onCameraSwitch() async {
    final CameraDescription cameraDescription =
        (_controller!.description == _cameras[0]) ? _cameras[1] : _cameras[0];

    if (_controller != null) {
      await _controller?.dispose();
    }

    _controller = CameraController(cameraDescription, ResolutionPreset.high);
    _controller!.addListener(() {
      if (mounted) setState(() {});
      if (_controller!.value.hasError) {
        SnackBar(
          content: Text("Camera Error: ${_controller!.value.errorDescription}"),
        );
      }
    });

    try {
      await _controller!.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> stopVideoRecording() async {
    if (!_controller!.value.isRecordingVideo) {
      return null;
    }
    _timerKey.currentState!.stopTimer();
    setState(() {
      _isRecording = false;
    });

    try {
      await _controller!.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  // Future<FileSystemEntity> getLastImage() async {
  //   final Directory extDir = await getApplicationDocumentsDirectory();
  //   final String dirPath = '${extDir.path}/media';
  //   final myDir = Directory(dirPath);
  //   List<FileSystemEntity> _images;
  //   _images = myDir.listSync(recursive: true, followLinks: false);
  //   _images.sort((a, b) {
  //     return b.path.compareTo(a.path);
  //   });
  //   var lastFile = _images[0];
  //   var extension = path.extension(lastFile.path);
  //   if (extension == '.jpeg') {
  //     return lastFile;
  //   } else {
  //     String thumb = await Thumbnails.getThumbnail(
  //         videoFile: lastFile.path, imageType: ThumbFormat.PNG, quality: 30);
  //     return File(thumb);
  //   }
  // }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description!);
    showAlert('Error: ${e.code}\n${e.description!}');
  }

  void showAlert(String message) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text("$message"),
          );
        });
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  @override
  Widget build(BuildContext context) {
    if (_controller != null) {
      if (!_controller!.value.isInitialized) {
        return Container();
      }
    } else {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.blue),
          ),
        ),
      );
    }
    if (!_controller!.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Stack(
        children: [
          _buildCameraPreview(),
          Positioned(
            top: 24.0,
            left: 12.0,
            child: IconButton(
              icon: Icon(Icons.flip_camera_ios_outlined),
              color: Colors.white,
              onPressed: _onCameraSwitch,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCameraPreview() {
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      child: Container(
        child: Transform.scale(
          scale: _controller!.value.aspectRatio / size.aspectRatio,
          child: Center(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      color: Theme.of(context).bottomAppBarColor,
      height: 100.0,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FutureBuilder(
            // future: getLastImage(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container(
                  width: 40.0,
                  height: 40.0,
                );
              }
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Gallery(),
                  ),
                ),
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.file(
                      snapshot.data! as File,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 28.0,
            child: IconButton(
              icon: Icon(
                (_isRecordingMode)
                    ? (_isRecording)
                        ? Icons.stop
                        : Icons.videocam
                    : Icons.camera_alt,
                size: 28.0,
                color: (_isRecording) ? Colors.red : Colors.black,
              ),
              onPressed: () {
                if (!_isRecordingMode) {
                  _captureImage();
                } else {
                  if (_isRecording) {
                    stopVideoRecording();
                  } else {
                    startVideoRecording();
                  }
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(
              (_isRecordingMode) ? Icons.camera_alt : Icons.videocam,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isRecordingMode = !_isRecordingMode;
              });
            },
          ),
        ],
      ),
    );
  }
}
