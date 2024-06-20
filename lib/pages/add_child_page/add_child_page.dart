import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../views/gender_selector_view.dart';
import '../add_child_page/add_child_page_bloc.dart';
import '../add_child_page/add_child_page_event.dart';
import '../../data/child_data.dart';
import '../../data/gender.dart';
import 'add_child_page_state.dart';

class AddChildPage extends StatelessWidget {
  final ChildData initialData;
  final bool hideBackButton;

  const AddChildPage({
    super.key,
    required this.initialData,
    this.hideBackButton = false
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !hideBackButton,
        title: Text(context.tr("addNewChild")),
      ),
      body: BlocProvider.value(
        value: BlocProvider.of<AddChildPageBloc>(context)..add(AddChildPageEventInit(initialData: initialData)),
        child: const SingleChildScrollView(
          child: AddChildPageStateWidget(),
        ),
      ),
    );
  }
}

class AddChildPageStateWidget extends StatefulWidget {
  const AddChildPageStateWidget({super.key});

  @override
  State<AddChildPageStateWidget> createState() => _AddChildPageStateWidget();
}

class _AddChildPageStateWidget extends State<AddChildPageStateWidget> {
  TextEditingController? nameTextController;

  @override
  void dispose() {
    nameTextController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddChildPageBloc, AddChildPageState>(
        builder: (context, state) {
          if (state is AddChildPageLoaded) {
            nameTextController ??= TextEditingController(text: state.data.name);

            return Column(
              children: [
                SizedBox(height: 200,
                  child: Stack(alignment: Alignment.center, children: [
                    state.data.photoPath == null
                        ? Container(color: Colors.grey,)
                        : Image.file(File(state.data.photoPath ?? ""),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fitWidth),

                    TextButton(
                      onPressed: () {
                        context.read<AddChildPageBloc>().add(
                            AddChildPageEventAddPhoto());
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white),
                      child: Text(state.data.photoPath == null
                          ? context.tr("addPhoto")
                          : context.tr("changePhoto")),),
                  ]),
                ),

                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child:
                    TextField(
                      controller: nameTextController,
                      decoration: InputDecoration(
                          labelText: context.tr("name"),
                          border: const OutlineInputBorder()
                      ),
                    ),
                ),

                const SizedBox(height: 40),
                SizedBox(
                    height: 100,
                    child: GenderSelector(
                      selectedGender: state.data.gender,
                      onSelectedIndex: (index) {
                        var gender = index == 0 ? Gender.male : Gender.female;
                        context
                            .read<AddChildPageBloc>()
                            .add(AddChildPageEventSetGender(gender: gender));
                      },
                    )),

                const SizedBox(height: 40),
                AddUpdateButton(
                  data: state.data,
                  nameTextController: nameTextController,
                ),

                // TODO: Disable Delete button for risk control
                // const SizedBox(height: 40),
                // DeleteButton(data: state.data),
              ],
            );
          } else {
            return Center(child: Text(context.tr("loading")));
          }
    });
  }
}

class AddUpdateButton extends StatelessWidget {
  final ChildData data;
  final TextEditingController? nameTextController;

  const AddUpdateButton(
      {super.key, required this.data, required this.nameTextController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 200, child: TextButton(
        style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.grey.shade300,
            padding: const EdgeInsets.all(20)),
        onPressed: () {
          final newData = data.copyWith(name: nameTextController?.text ?? "");
          if (data.id != null) {
            context
                .read<AddChildPageBloc>()
                .add(AddChildPageEventUpdateData(newData: newData));
          } else {
            context
                .read<AddChildPageBloc>()
                .add(AddChildPageEventAddData(newData: newData));
          }
          Fluttertoast.showToast(
            gravity: ToastGravity.TOP,
            fontSize: 20,
            msg: data.id != null ? context.tr("updated") : context.tr("added")
          );
          Navigator.pop(context);
        },
        child: Text(data.id != null ? context.tr("update") : context.tr("add"))),
    );
  }
}

class DeleteButton extends StatelessWidget {
  final ChildData data;

  const DeleteButton({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            foregroundColor: Colors.red,
            backgroundColor: Colors.red.shade50,
            padding: const EdgeInsets.all(20)),
        onPressed: (data.id == null)
            ? null
            : () {
                context.read<AddChildPageBloc>().add(AddChildPageEventDelete());
                Fluttertoast.showToast(
                  gravity: ToastGravity.TOP,
                  fontSize: 20,
                  msg: "Deleted"
                );
                Navigator.pop(context);
              },
        child: const Text("Delete"));
  }
}