import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RecordingTest extends StatefulWidget {
  final CameraDescription camera;
  final WebSocketChannel channel;
  RecordingTest({
    Key key,
    @required this.camera,
    @required this.channel,
  }) : super(key: key);

  _RecordingTestState createState() => _RecordingTestState();
}

class _RecordingTestState extends State<RecordingTest> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool _recording = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.low,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(title: Text("Take a picture.")),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            if (!_recording) {
              await _controller.startImageStream((img)  {
                print("${img.format.group} ${img.width} ${img.height} ${img.planes.length}");
                widget.channel.sink.add(img.planes.first.bytes);
              });
              _recording = true;
            } else {
              await _controller.stopImageStream();
              _recording = false;
            }
          } catch (e) {
            print(e);
          }
        },
      ),
    ));
  }
}
