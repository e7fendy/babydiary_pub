
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../data/gender.dart';

class MyGender {
  String name;
  IconData icon;
  bool isSelected;
  MyGender(this.name, this.icon, this.isSelected);
}

class GenderSelector extends StatefulWidget {
  final Gender? selectedGender;
  final void Function(int) onSelectedIndex;

  const GenderSelector({
    super.key,
    this.selectedGender,
    required this.onSelectedIndex
  });

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  List<MyGender> genders = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    genders.add(MyGender(context.tr("male"), Icons.male, false));
    genders.add(MyGender(context.tr("female"), Icons.female, false));
    // genders.add(MyGender("Others", Icons.transgender, false));

    if (widget.selectedGender != null) {
      switch (widget.selectedGender) {
        case Gender.male:
          genders[0].isSelected = true;
          break;
        case Gender.female:
          genders[1].isSelected = true;
          break;
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: genders.length,
        itemBuilder: (context, index) {
          return InkWell(
            splashColor: Colors.pinkAccent,
            onTap: () {
              setState(() {
                for (var gender in genders) {
                  gender.isSelected = false;
                }
                genders[index].isSelected = true;

                widget.onSelectedIndex(index);
              });
            },
            child: CustomRadio(gender: genders[index]),
          );
        });
  }
}

class CustomRadio extends StatelessWidget {
  final MyGender gender;

  const CustomRadio({super.key, required this.gender});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: gender.isSelected ? const Color(0xFF3B4257) : Colors.white,
        child: Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                gender.icon,
                color: gender.isSelected ? Colors.white : Colors.grey,
                size: 40,
              ),
              const SizedBox(height: 10),
              Text(
                gender.name,
                style: TextStyle(
                    color: gender.isSelected ? Colors.white : Colors.grey),
              )
            ],
          ),
        ));
  }
}
