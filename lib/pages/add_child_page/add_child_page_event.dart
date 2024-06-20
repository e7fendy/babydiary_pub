import 'package:equatable/equatable.dart';

import '../../data/child_data.dart';
import '../../data/gender.dart';

abstract class AddChildPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class AddChildPageEventInit extends AddChildPageEvent {
  final ChildData initialData;

  AddChildPageEventInit({
    required this.initialData,
  });

  @override
  List<Object> get props => [initialData];
}

final class AddChildPageEventAddData extends AddChildPageEvent {
  final ChildData newData;

  AddChildPageEventAddData({
    required this.newData,
  });

  @override
  List<Object> get props => [newData];
}

final class AddChildPageEventUpdateData extends AddChildPageEvent {
  final ChildData newData;

  AddChildPageEventUpdateData({
    required this.newData,
  });

  @override
  List<Object> get props => [newData];
}

final class AddChildPageEventSetGender extends AddChildPageEvent {
  final Gender gender;

  AddChildPageEventSetGender({
    required this.gender,
  });

  @override
  List<Object> get props => [gender];
}

final class AddChildPageEventDelete extends AddChildPageEvent {
}

final class AddChildPageEventAddPhoto extends AddChildPageEvent {
}