import 'package:equatable/equatable.dart';

import '../../data/record_data.dart';

abstract class HomePageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class HomePageEventInit extends HomePageEvent {
}

final class HomePageEventUpdate extends HomePageEvent {
}

final class HomePageEventDelete extends HomePageEvent {
  final RecordData data;
  HomePageEventDelete({required this.data});
  @override
  List<Object> get props => [data];
}

final class HomePageEventAddData extends HomePageEvent {
  final RecordData data;
  HomePageEventAddData({required this.data});
  @override
  List<Object> get props => [data];
}

final class HomePageEventSelectChild extends HomePageEvent {
  final int index;
  HomePageEventSelectChild({required this.index});
  @override
  List<Object> get props => [index];
}