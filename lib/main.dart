
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant/employee_model.dart';
import 'package:restaurant/pin_password_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp(this.cameras);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: PinPasswordPage(cameras),
      // home: CameraScreen(cameras),
    );
  }
}




