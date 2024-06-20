import 'dart:io';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../data/child_data.dart';
import '../../data/gender.dart';
import '../../data/record_data.dart';
import '../../utils/data_manager.dart';
import '../add_child_page/add_child_page.dart';
import '../settings_page/settings_page.dart';
import 'home_page_row_widget.dart';
import 'home_page_bloc.dart';
import 'home_page_event.dart';
import 'home_page_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<HomePageBloc>(context)..add(HomePageEventInit()),
      child: const SafeArea(child:
        Scaffold(
          body: HomePageStateWidget(),
        ),
      )
    );
  }
}

class HomePageStateWidget extends StatefulWidget {
  const HomePageStateWidget({super.key});

  @override
  State<HomePageStateWidget> createState() => _HomePageStateWidget();
}

class _HomePageStateWidget extends State<HomePageStateWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageState>(
        listener: (context, state) async {
      if (state is HomePageLoaded) {
        if (state.childrenData.isEmpty) {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddChildPage(
                      initialData: ChildData(
                        gender: Gender.male,
                        name: "",
                      ),
                      hideBackButton: true,
                    )),
          );

          if (context.mounted) {
            context.read<HomePageBloc>().add(HomePageEventUpdate());
          }
        }
      }
    }, builder: (context, state) {
      return BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
        if (state is HomePageLoaded) {

          return Column(children: [
            SizedBox(height: 200, child:
              Stack(children: [
                HomePageCarousel(childrenData: state.childrenData),
                Container(width: double.infinity, height: double.infinity, alignment: Alignment.topRight, child:
                    Padding(padding: const EdgeInsets.all(3), child:
                      IconButton.filled(
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => const SettingsPage()),);
                          },
                          icon: const Icon(Icons.settings)
                      ),
                    ),
                )
              ])
            ),

            Expanded(
                child: state.data.isEmpty ? Center(child: Text(context.tr("noData"))) : ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                return HomePageRowWidget(
                  data: state.data[index],
                  prevData: index > 0 ? state.data[index - 1] : null,
                  childrenData: state.childrenData,
                  onDeleted: (data) {
                    context
                        .read<HomePageBloc>()
                        .add(HomePageEventDelete(data: data));
                    Fluttertoast.showToast(
                      gravity: ToastGravity.TOP,
                      fontSize: 20,
                      msg: context.tr("deleted")
                    );
                  },
                );
              },
            )),

            SizedBox(
              height: 80,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: DataManager.types.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextButton.icon(
                            icon: Icon(DataManager.typeIcons[DataManager.types[index]]),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.primaries[index],
                              backgroundColor: Colors.primaries[index].withAlpha(30),
                              minimumSize: const Size(120, 80),
                            ),
                            label: Text(context.tr(DataManager.types[index]),
                                style: const TextStyle(fontSize: 20)),
                            onPressed: () {
                              _showDetailsDialog(context, (note) {
                                context.read<HomePageBloc>().add(
                                  HomePageEventAddData(
                                      data: RecordData(
                                        note: note,
                                        type: DataManager.types[index],
                                      )
                                  )
                                );
                              Fluttertoast.showToast(
                                gravity: ToastGravity.TOP,
                                fontSize: 20,
                                msg: context.tr("added")
                              );
                              });
                            }));
                  }),
            ),
          ]);
        }

        return Center(child: Text(context.tr("loading")));
      });
    });
  }

  final TextEditingController _noteTextFieldController = TextEditingController();
  Future<void> _showDetailsDialog(
      BuildContext context,
      void Function(String note) onPressed,
  ) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.tr("details")),
          content:
          TextField(
            controller: _noteTextFieldController,
            decoration: InputDecoration(
                labelText: context.tr("note"),
                border: const OutlineInputBorder()
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(context.tr("cancel")),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
            TextButton(
              child: Text(context.tr("done")),
              onPressed: () {
                setState(() {
                  onPressed(_noteTextFieldController.text);
                  _noteTextFieldController.clear();
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      });
  }
}

class HomePageCarousel extends StatelessWidget {
  final List<ChildData> childrenData;

  const HomePageCarousel({
    super.key,
    required this.childrenData
  });

  @override
  Widget build(BuildContext context) {
    return FlutterCarousel(
      options: CarouselOptions(
        onPageChanged: (index, reason) {
          context.read<HomePageBloc>().add(HomePageEventSelectChild(index: index));
        },
        height: 200,
        viewportFraction: 1.0,
        showIndicator: true,
        slideIndicator: const CircularSlideIndicator(),
      ),
      items: childrenData.map((childData) {
        return Builder(builder: (BuildContext context) {
          return Stack(alignment: Alignment.bottomLeft, children: [
            childData.photoPath == null
                ? Container(color: Colors.grey,)
                : Image.file(File(childData.photoPath ?? ""),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fitWidth),

            Container(width: double.infinity, color: Colors.black.withAlpha(125), child:
            Padding(padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5), child:
            Text(childData.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
            ),
            ),
          ]);
        },
        );
      }).toList(),
    );
  }

}