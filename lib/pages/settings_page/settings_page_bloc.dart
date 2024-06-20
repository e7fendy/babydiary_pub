

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/child_data.dart';
import '../../utils/data_manager.dart';
import 'settings_page_event.dart';
import 'settings_page_state.dart';

class SettingsPageBloc extends Bloc<SettingsPageEvent, SettingsPageState> {
  late DataManager dbHelper;

  SettingsPageBloc() : super(const SettingsPageState(childrenData: [])) {
    dbHelper = DataManager();

    on<SettingsPageEventGetChildrenData>((event, emit) async {
      List<ChildData> data = await dbHelper.getChildrenData();
      emit(SettingsPageState(childrenData: data));
    });
  }
}