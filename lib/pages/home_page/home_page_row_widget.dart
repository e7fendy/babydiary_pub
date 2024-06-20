import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../data/child_data.dart';
import '../../data/gender.dart';
import '../../data/record_data.dart';
import '../../utils/data_manager.dart';
import '../../utils/datetime_utils.dart';

class HomePageRowWidget extends StatelessWidget {
  final RecordData data;
  final RecordData? prevData;
  final List<ChildData> childrenData;
  final void Function(RecordData) onDeleted;

  const HomePageRowWidget({
    super.key,
    required this.data,
    required this.prevData,
    required this.childrenData,
    required this.onDeleted
  });

  bool showDate() {
    final myDate = DatetimeUtils.timestampToDateStr(data.createdAt ?? 0);
    final prevDate = DatetimeUtils.timestampToDateStr(prevData?.createdAt ?? 0);
    return myDate != prevDate;
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const ScrollMotion(),
          children: [
            SlideAction(
              color: const Color(0xFFFE4A49),
              icon: Icons.delete,
              onPressed: (_) {
                onDeleted(data);
              },
            )
          ],
        ),
        child: _HomePageRowWidget(
          data: data,
          childrenData: childrenData,
          showDate: showDate(),
        ));
  }
}

class SlideAction extends StatelessWidget {
  const SlideAction({
    super.key,
    required this.color,
    required this.icon,
    required this.onPressed,
    this.flex = 1,
  });

  final Color color;
  final IconData icon;
  final int flex;
  final SlidableActionCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      flex: flex,
      backgroundColor: color,
      foregroundColor: Colors.white,
      onPressed: onPressed,
      icon: icon,
    );
  }
}

class _HomePageRowWidget extends StatelessWidget {
  final RecordData data;
  final List<ChildData> childrenData;
  final bool showDate;

  const _HomePageRowWidget({
    required this.data,
    required this.childrenData,
    required this.showDate
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(width: 120, child: Row(children: [
        SizedBox(width: 70, child: Text(
          showDate ? DatetimeUtils.timestampToDateStr(data.createdAt ?? 0) : "",
          style: const TextStyle(
            fontSize: 18,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        )),
        SizedBox(width: 50, child: Icon(size: 30, DataManager.typeIcons[data.type]),),
      ],),),
      title: Text(context.tr(data.type ?? ""), style: const TextStyle(fontSize: 18),),
      subtitle: data.note?.isEmpty == false ? Text(data.note!) : null,
      trailing: Text(
        DatetimeUtils.timestampToTimeStr(data.createdAt ?? 0),
        style: const TextStyle(
          fontSize: 18,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }

  ChildData getChildData(int childId) {
    if (childrenData.isEmpty) {
      return ChildData(gender: Gender.male, name: "");
    }
    return childrenData.firstWhere((element) => element.id == childId);
  }
}
