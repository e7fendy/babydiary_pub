import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/child_data.dart';
import '../../repo/data_repository.dart';
import '../../utils/data_manager.dart';
import 'home_page_event.dart';
import 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final DataRepository dataRepository;
  late DataManager dataManager;

  late final StreamSubscription _subscription;
  late final StreamSubscription _subscriptionChild;

  HomePageBloc({required this.dataRepository}) : super(HomePageInitial()) {
    dataManager = DataManager();

    _subscription = dataRepository.childrenStream.stream.listen((_) async {
      add(HomePageEventUpdate());
    }, onError: (error) {
      // print('$error');
    });

    _subscriptionChild = dataRepository.childrenStream.stream.listen((_) async {
      add(HomePageEventUpdate());
    }, onError: (error) {
      // print('$error');
    });

    on<HomePageEventInit>((event, emit) async {
      final childrenData = await dataManager.getChildrenData();
      if (childrenData.isEmpty) {
        emit(HomePageLoaded(data: const [], childrenData: childrenData, selectedChildIndex: 0));
        return;
      }
      final selectedChildId = childrenData[0].id;
      final items = await dataManager.getRecordData(selectedChildId!);

      for (var i=0; i<childrenData.length; i++) {
        await dataRepository.childrenStream.addData(childrenData[i]);
      }
      emit(HomePageLoaded(data: items, childrenData: childrenData, selectedChildIndex: 0));
    });

    on<HomePageEventUpdate>((event, emit) async {
      if (state is HomePageLoaded) {
        var myState = state as HomePageLoaded;

        final childrenData = await dataManager.getChildrenData();
        final selectedChildId = childrenData[myState.selectedChildIndex].id;

        final items = await dataManager.getRecordData(selectedChildId!);
        emit(myState.copyWith(data: items, childrenData: childrenData));
      }
    });

    on<HomePageEventAddData>((event, emit) async {
      if (state is HomePageLoaded) {
        var myState = state as HomePageLoaded;

        final childrenData = await dataManager.getChildrenData();
        final selectedChildId = childrenData[myState.selectedChildIndex].id;

        final myData = event.data.copyWith(childId: selectedChildId);
        await dataManager.insertRecordData(myData);

        add(HomePageEventUpdate());
      }
    });

    on<HomePageEventDelete>((event, emit) async {
      final data = event.data;
      await dataManager.deleteRecordDataById(data.id);
      add(HomePageEventUpdate());
    });

    on<HomePageEventSelectChild>((event, emit) async {
      final selectedIndex = event.index;

      if (state is HomePageLoaded) {
        var myState = state as HomePageLoaded;

        final childrenData = await dataManager.getChildrenData();
        final selectedChildId = childrenData[selectedIndex].id;

        final items = await dataManager.getRecordData(selectedChildId!);
        emit(myState.copyWith(data: items, selectedChildIndex: selectedIndex));
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
