import 'package:camera/camera.dart';
import 'package:camera_test/camerapreview.dart';
import 'package:camera_test/recordingtest.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

Future<void> main() async {
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        camera: firstCamera,
      ),
    ),
  );
}


/*
Use this if you want to test Image streaming
Future<void> main() async {
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: RecordingTest(
        camera: firstCamera,
        channel: IOWebSocketChannel.connect('ws://192.168.178.53:8585')
      ),
    ),
  );
}
*/