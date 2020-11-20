import 'package:camera/camera.dart';
import 'package:colorbucket/bloc/home/home_event.dart';
import 'package:colorbucket/bloc/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeStateInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if(event is HomeEventInitial){
      yield* _handleInitialEvent();
    }
  }


  Stream<HomeState> _handleInitialEvent() async* {
    try{
      List<CameraDescription> cameraDescriptions = [];
      var cameraIndex = await availableCameras().then((cameras) {
        if(cameras.length > 0 ){ 
          cameraDescriptions = cameras;
          return 0;
        }
        return null;
      }).catchError((err){
        print("Error when get availableCameras(): $err");
        return null;
      });
      yield HomeStateCameraConfig(
        cameraIndex: cameraIndex, 
        cameraDescription: cameraDescriptions
      );
    }catch(e){
      print("Exception occured in _handleInitialEvent(): $e");
      yield HomeStateShowToast(message: "Error occured when detect camera");
    }
  }

}