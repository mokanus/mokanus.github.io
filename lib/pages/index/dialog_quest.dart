import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:tingfm/entities/classify.dart';

class DialogQuest extends StatefulWidget {
  final List<Classify> classifies;
  const DialogQuest({super.key, required this.classifies});

  @override
  State<DialogQuest> createState() => DialogQuestState();
}

class DialogQuestState extends State<DialogQuest> {
  List<String> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
            color: Color.fromARGB(255, 234, 78, 94),
          ),
          height: 60,
          width: ScreenUtil().screenWidth,
          child: const Text(
            "喜欢什么类型的专辑呢？",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: Column(
              children: [
                Lottie.asset(
                  'assets/jsons/lottie_a.json',
                  fit: BoxFit.contain,
                  width: 64,
                  height: 64,
                ),
                buildCheckBoxWidgets(),
              ],
            )),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
          child: IconsButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: '收到',
            iconData: Icons.arrow_right_rounded,
            color: const Color.fromARGB(255, 234, 78, 94),
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildCheckBoxWidgets() {
    List<Widget> items = [];

    for (var i in widget.classifies) {
      items.add(
        CheckboxListTile(
          title: Text(i.classify),
          value: selectedItems.contains(i.classify),
          onChanged: (value) {
            handleCheckbox(value, i.classify);
          },
        ),
      );
    }
    return Column(
      children: items,
    );
  }

  // 处理多选框变化
  void handleCheckbox(bool? value, String item) {
    setState(() {
      if (value!) {
        selectedItems.add(item);
      } else {
        selectedItems.remove(item);
      }
    });
  }
}
