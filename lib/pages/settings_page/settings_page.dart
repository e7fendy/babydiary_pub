import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';

import 'settings_page_event.dart';
import '../../data/child_data.dart';
import '../../data/gender.dart';
import '../add_child_page/add_child_page.dart';
import 'settings_page_bloc.dart';
import 'settings_page_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr("settings")),
      ),
      body: BlocProvider(
        create: (_) =>
            SettingsPageBloc()..add(SettingsPageEventGetChildrenData()),
        child: const SettingsPageWidget(),
      ),
    );
  }
}

class SettingsPageWidget extends StatefulWidget {
  const SettingsPageWidget({super.key});

  @override
  State<SettingsPageWidget> createState() => _SettingsPageWidget();
}

class _SettingsPageWidget extends State<SettingsPageWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsPageBloc, SettingsPageState>(
        builder: (context, state) {
      List<SettingsTile> childrenTiles = [];
      for (ChildData child in state.childrenData) {
        IconData iconData =
            child.gender == Gender.male ? Icons.male : Icons.female;
        childrenTiles.add(SettingsTile.navigation(
          leading: Icon(iconData),
          title: Text(child.name),
          onPressed: (_) => _routeToChildPage(context, child),
        ));
      }
      childrenTiles.add(
        SettingsTile.navigation(
          leading: const Icon(Icons.add),
          title: Text(context.tr("addNewChild")),
          onPressed: (_) =>  _routeToChildPage(context, ChildData(gender: Gender.male, name: "")),
        ),
      );

      return SettingsList(
        applicationType: ApplicationType.both,
        sections: [
          SettingsSection(title: Text(context.tr("children")), tiles: childrenTiles),
          SettingsSection(
            title: Text(context.tr("aboutUs")),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.link),
                title: const Text("BabyDiary v1.0.0"),
                onPressed: (_) {
                  // TODO: go to appstore
                },
              ),
            ],
          ),
        ],
      );
    });
  }

  Future<void> _routeToChildPage(BuildContext context, ChildData data) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddChildPage(
            initialData: data,
          )),
    );
    
    if (!context.mounted) return;
    BlocProvider.of<SettingsPageBloc>(context).add(SettingsPageEventGetChildrenData());
  }
}
