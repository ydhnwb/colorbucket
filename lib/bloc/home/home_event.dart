import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable{}

class HomeEventInitial implements HomeEvent {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => false;

}