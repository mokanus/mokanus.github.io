import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("反馈和建议"),
        elevation: 0.1,
      ),
      body: Center(
          child: Column(
        children: [
          TextField(
            controller: _inputController,
            decoration: const InputDecoration(
                labelText: "没有喜欢听的书？",
                hintText: "可以反馈你想听的专辑",
                prefixIcon: Icon(Icons.multitrack_audio)),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(onPressed: () => {}, child: const Text("提交反馈"))
        ],
      )),
    );
  }
}
