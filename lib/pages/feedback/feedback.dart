import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:tingfm/api/feedback.dart';
import 'package:tingfm/api/router.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _onPressed() async {
    var content = _inputController.text;
    if (content.isEmpty) {
      return;
    }
    try {
      Map<String, dynamic> params = {"content": content};
      await FeedbackAPI.feedback(
        url: APIRouter.router(APIRouter.feedbackAPI),
        params: params,
        context: context,
      );

      // ignore: use_build_context_synchronously
      MotionToast.success(
        title: const Text("成功"),
        description: const Text("收到你的反馈啦，请持续关注!"),
        position: MotionToastPosition.bottom,
      ).show(context);
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("反馈和建议"),
        elevation: 0.1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                  labelText: "没有喜欢听的书？",
                  hintText: "可以反馈你想听的专辑",
                  prefixIcon: Icon(
                    Icons.multitrack_audio,
                    color: Color.fromARGB(255, 234, 78, 94),
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: _onPressed,
              child: const Text("提交反馈"),
            )
          ],
        )),
      ),
    );
  }
}
