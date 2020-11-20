import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeState extends Equatable {}

class HomeStateInitial implements HomeState {
  @override
  List<Object> get props => [];
  @override
  bool get stringify => false;
}

class HomeStateCameraConfig implements HomeState {
  final cameraIndex;
  final List<CameraDescription> cameraDescription;
  HomeStateCameraConfig({@required this.cameraIndex, @required this.cameraDescription});
  @override
  List<Object> get props => [cameraIndex];
  @override
  bool get stringify => false;  
}

class HomeStateShowToast implements HomeState {
  final String message;
  HomeStateShowToast({@required this.message});
  @override
  List<Object> get props => [message];
  @override
  bool get stringify => false;
}