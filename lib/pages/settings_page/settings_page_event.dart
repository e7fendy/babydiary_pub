
import 'package:equatable/equatable.dart';


abstract class SettingsPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class SettingsPageEventGetChildrenData extends SettingsPageEvent { }