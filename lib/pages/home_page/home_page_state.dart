
import 'package:equatable/equatable.dart';

import '../../data/child_data.dart';
import '../../data/record_data.dart';

class HomePageState extends Equatable {
  @override
  List<Object> get props => [];
}

final class HomePageInitial extends HomePageState {
}

class HomePageLoaded extends HomePageState {
  final List<RecordData> data;
  final List<ChildData> childrenData;
  final int selectedChildIndex;

  HomePageLoaded({
    required this.data,
    required this.childrenData,
    required this.selectedChildIndex
  });

  HomePageLoaded copyWith({
    List<RecordData>? data,
    List<ChildData>? childrenData,
    int? selectedChildIndex
  }) {
    return HomePageLoaded(
        data: data ?? this.data,
        childrenData: childrenData ?? this.childrenData,
        selectedChildIndex: selectedChildIndex ?? this.selectedChildIndex
    );
  }

  @override
  List<Object> get props => [data, childrenData, selectedChildIndex];
}