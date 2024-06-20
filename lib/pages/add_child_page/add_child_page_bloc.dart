import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../repo/data_repository.dart';
import '../../utils/data_manager.dart';
import 'add_child_page_event.dart';
import 'add_child_page_state.dart';

class AddChildPageBloc extends Bloc<AddChildPageEvent, AddChildPageState> {
  final DataRepository dataRepository;
  late DataManager dataManager;

  AddChildPageBloc(this.dataRepository) : super(AddChildPageInit()) {
    dataManager = DataManager();

    on<AddChildPageEventInit>((event, emit) async {
      emit(AddChildPageLoaded(data: event.initialData));
    });

    on<AddChildPageEventAddData>((event, emit) async {
      await dataManager.insertChildData(event.newData);
      await dataRepository.childrenStream.addData(event.newData);
    });

    on<AddChildPageEventUpdateData>((event, emit) async {
      await dataManager.updateChildData(event.newData);

      final childrenData = await dataManager.getChildrenData();
      final childIndex = childrenData.indexWhere((child) => child.id == event.newData.id);
      await dataRepository.childrenStream.updateData(childIndex, event.newData);
    });

    on<AddChildPageEventSetGender>((event, emit) async {
      if (state is AddChildPageLoaded) {
        var myState = state as AddChildPageLoaded;
        emit(AddChildPageLoaded(
            data: myState.data.copyWith(gender: event.gender)));
      }

    });

    on<AddChildPageEventDelete>((event, emit) async {
      if (state is AddChildPageLoaded) {
        var myState = state as AddChildPageLoaded;
        await dataManager.deleteChildDataById(myState.data.id);
      }
    });

    on<AddChildPageEventAddPhoto>((event, emit) async {
      if (state is AddChildPageLoaded) {
        var myState = state as AddChildPageLoaded;
        final picker = ImagePicker();
        final XFile? pickedImage = await picker.pickImage(
            source: ImageSource.gallery);
        if (pickedImage != null) {
          // copy file and save the path
          final appDir = await getApplicationDocumentsDirectory();
          final newFile = "${appDir.path}/${pickedImage.name}";
          final savedImage = await File(pickedImage.path).copy(newFile);
          emit(AddChildPageLoaded(
              data: myState.data.copyWith(photoPath: savedImage.path)));
        }
      }
    });
  }
}
