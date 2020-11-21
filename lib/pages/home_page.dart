import 'package:camera/camera.dart';
import 'package:colorbucket/bloc/home/home_bloc.dart';
import 'package:colorbucket/bloc/home/home_event.dart';
import 'package:colorbucket/bloc/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraController _cameraController;
  HomeBloc _homeBloc;
  int _selectedCameraIndex;

  _initCamera() => _homeBloc.add(HomeEventInitial());

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc();
    _initCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer(
      cubit: _homeBloc,
      listener: (context, state) => _handleState(state),
      builder: (context, state) {
        if (_selectedCameraIndex == null) {
          return Container(
            child: Center(
              child: Text("Cannot access your camera"),
            ),
          );
        } else {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: _cameraView()
                ),
                SizedBox(height: 16.0),
                RaisedButton(
                  shape: CircleBorder(),
                  color: Colors.white,
                  onPressed: () => {},
                )
              ],
            )
          );
        }
      },
    ));
  }

  _cameraView(){
    if(_cameraController == null || !_cameraController.value.isInitialized){
      return Container(
        child: Center(
          child: Text("Loading", style: TextStyle(fontWeight: FontWeight.bold))
        )
      );
    }
    return AspectRatio(
      aspectRatio: _cameraController.value.aspectRatio,
      child: CameraPreview(_cameraController),
    );
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (_cameraController != null) {
      await _cameraController.dispose();
    }
    _cameraController = CameraController(
      cameraDescription, 
      ResolutionPreset.medium);
    _cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (_cameraController.value.hasError) {
        print("Camera error: ${_cameraController.value.hasError}");
        _showToast("Camera error. Cannot access open a camera");
      }
    });

    try {
      await _cameraController.initialize();
    } on CameraException catch (e) {
      print("Exception when initialize camera controller : $e");
      _showToast("Exception when initialize camera controller");
    }

    setState(() {});
  }

  _handleState(state) {
    if (state is HomeStateShowToast) {
      _showToast(state.message);
    } else if (state is HomeStateCameraConfig) {
      _selectedCameraIndex = state.cameraIndex;
      if(_selectedCameraIndex != null){
        _initCameraController(state.cameraDescription[0]);
      }
    }
  }

  _showToast(message) => Toast.show(message, context);
}
