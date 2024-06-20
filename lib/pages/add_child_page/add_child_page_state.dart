
import 'package:equatable/equatable.dart';

import '../../data/child_data.dart';

class AddChildPageState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddChildPageInit extends AddChildPageState {
}

class AddChildPageLoaded extends AddChildPageState {
  final ChildData data;
  AddChildPageLoaded({required this.data});
  @override
  List<Object> get props => [data];
}