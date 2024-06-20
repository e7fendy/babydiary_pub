
import 'package:equatable/equatable.dart';

import '../../data/child_data.dart';

class SettingsPageState extends Equatable {
  final List<ChildData> childrenData;

  const SettingsPageState({required this.childrenData});

  @override
  List<Object> get props => [childrenData];
}