import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(
    AppHere(cameras: cameras),
  );
}

class AppHere extends StatelessWidget {
  const AppHere({required this.cameras, Key? key}) : super(key: key);
  final List<CameraDescription>? cameras;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.pinkAccent.shade100,
        body: CameraWebCaptureApp(
          cameras: cameras,
        ),
      ),
    );
  }
}
