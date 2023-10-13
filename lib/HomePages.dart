import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase/storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:screenshot/screenshot.dart';

class HomePages extends StatelessWidget {
  const HomePages({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GOODINSHIG',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //late CameraController? _cameraController;
  //VideoPlayerController? _videoController;
  final ImagePicker _imagePicker = ImagePicker();
  final Location _location = Location();

  bool _isLoading = false;

//cria objeto autenticador na api do google
  late GoogleSignIn _googleSignIn;
//imagem pega
  XFile? xFile;
  //controla o screenshot
  ScreenshotController screenshotController = ScreenshotController();

  //descrição da imagem
  String description = "....";

  late ImagemFinal imagemFinal;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    imagemFinal = ImagemFinal(xFile: xFile, description: description);
    //_initializeVideoPlayer();
  }

  Future<void> _initializeCamera() async {
    //   permission.PermissionStatus p = await permission.Permission.camera.request();
    //   print("status ${p}");
    //   final cameras = await availableCameras();
    //   print("cameras ${cameras}");
    //   final camera = cameras.first;
    //   //_cameraController = CameraController(camera, ResolutionPreset.high);

    //  // await _cameraController!.initialize();
    //   print("iniciou");
  }

  // void _initializeVideoPlayer() {
  //   _videoController = VideoPlayerController.network(
  //     'URL_DO_SEU_VIDEO',
  //   )..initialize().then((_) {
  //       setState(() {});
  //     });
  // }

  Future<XFile?> _takePicture() async {
    //pega imagem da câmera
    xFile = await _imagePicker.pickImage(source: ImageSource.camera);

    final locationData = await _location.getLocation();
    setState(() {
      description =
          "localização: ${locationData.latitude},${locationData.longitude}";
    });
    setState(() {
      xFile;
      imagemFinal = ImagemFinal(xFile: xFile, description: description);
    });
    var screenshot = await screenshotController.captureFromWidget(imagemFinal);
    var isSaved = await ImageGallerySaver.saveImage(screenshot, quality: 100);
    print("finalizou ${isSaved}");
    await ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Imagem salva com sucesso!")));
    // if (_cameraController == null || !_cameraController!.value.isInitialized) {
    //   print('Error: select a camera first.');
    //   return null;
    // }

    // if (_cameraController!.value.isTakingPicture) {
    //   // A capture is already pending, do nothing.
    //   return null;
    // }

    // try {
    //   print("prgou foto");
    //   final XFile file = await _cameraController!.takePicture();
    //   return file;
    // } on CameraException catch (e) {
    //   //_showCameraException(e);
    //   print("eeeeeeeee ${e}");
    //   return null;
    // }
  }

  @override
  void dispose() {
    // _cameraController?.dispose();
    //_videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localizador de Área'),
      ),
      body: Column(
        children: [
          // Expanded(
          //   child: _videoController!.value.isInitialized
          //       ? AspectRatio(
          //           aspectRatio: _videoController!.value.aspectRatio,
          //           child: VideoPlayer(_videoController!),
          //         )
          //       : const CircularProgressIndicator(),
          // ),
          (xFile != null)
              ? Screenshot(controller: screenshotController, child: imagemFinal)
              : SizedBox(),
          ElevatedButton(
//             onPressed: () async {
//               print("*******");
//               //var status = await permission.Permission.camera.status;
//               permission.PermissionStatus ps =
//                   await permission.Permission.camera.request();

//               print("yyyyy ${ps}");
//               // if (status.isDenied) {
//               //   print("permissao negada");
//               //   // We didn't ask for permission yet or the permission has been denied before, but not permanently.
//               // }
// // You can can also directly ask the permission about its status.
// // if (await Permission.location.isRestricted) {
// //   // The OS restricts access, for example because of parental controls.
// //   print("permissao parent");
// // }
//               XFile? xFilee = await _imagePicker.pickImage(
//                   source: ImageSource.camera,
//                   imageQuality: 100,);
//               XFile? xFile = await _imagePicker.pickMedia();
//             },
            onPressed: _takePicture,
            child: const Text('Tirar Foto'),
          ),
          ElevatedButton(
            //onPressed: _getLocation,
            onPressed: () {
              _getLocation();
            },
            child: const Text('Obter Localização'),
          ),

          (xFile != null)
              ? (_isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        await StorageClient().uploadImageToFirebase(
                            imageFile: File(xFile!.path));

                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: const Text('Enviar foto'),
                    ))
              : const SizedBox.shrink(),
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
      await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Latitude: ${locationData.latitude}' +
              ' Longitude: ${locationData.longitude}' +
              ' Data e Hora: ${DateTime.fromMillisecondsSinceEpoch(locationData.time!.toInt())}')));
    } catch (e) {
      print(e);
    }
  }
}

class ImagemFinal extends StatelessWidget {
  const ImagemFinal({
    super.key,
    required this.xFile,
    required this.description,
  });

  final XFile? xFile;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      height: 600,
      child: Stack(children: [
        xFile != null ? Image.file(File(xFile!.path)) : SizedBox(),
        Positioned(top: 32, left: 32, child: Text(description))
      ]),
    );
  }
}
