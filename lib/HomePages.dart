import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_application_1/LoginPages.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_player/video_player.dart';
import 'package:location/location.dart';

class HomePages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GOODINSHIG',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController? _cameraController;
  VideoPlayerController? _videoController;
  Location _location = Location();
//cria objeto autenticador na api do google
  late GoogleSignIn _googleSignIn;
  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeVideoPlayer();
    _googleSignIn = GoogleSignIn(scopes: [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ]);
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _cameraController = CameraController(camera, ResolutionPreset.medium);
    await _cameraController!.initialize();
  }

  void _initializeVideoPlayer() {
    _videoController = VideoPlayerController.network(
      'URL_DO_SEU_VIDEO',
    )..initialize().then((_) {
        setState(() {});
      });
  }

  Future<void> _takePicture() async {
    if (_cameraController != null) {
      try {
        final XFile picture = await _cameraController!.takePicture();
        // Agora você pode fazer algo com a imagem, como enviá-la para algum lugar.
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _googleSignIn.disconnect();
            Get.off(LoginPages());
          },
          label: Text("Deslogar")),
      appBar: AppBar(
        title: Text('Localizador de Área'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _videoController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                : CircularProgressIndicator(),
          ),
          ElevatedButton(
            onPressed: _takePicture,
            child: Text('Tirar Foto'),
          ),
          ElevatedButton(
            onPressed: _getLocation,
            child: Text('Obter Localização'),
          ),
        ],
      ),
    );
  }

  Future<void> _getLocation() async {
    try {
      final locationData = await _location.getLocation();
      // Agora você pode acessar latitude, longitude, data e hora, etc., de locationData.
      print('Latitude: ${locationData.latitude}');
      print('Longitude: ${locationData.longitude}');
      print(
          'Data e Hora: ${DateTime.fromMillisecondsSinceEpoch(locationData.time!.toInt())}');
    } catch (e) {
      print(e);
    }
  }
}
