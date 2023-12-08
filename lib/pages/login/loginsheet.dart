import 'package:flutter/material.dart';
import 'package:tingfm/services/auth_service.dart';

class LoginSheet extends StatefulWidget {
  const LoginSheet({Key? key}) : super(key: key);

  @override
  LoginSheetState createState() => LoginSheetState();
}

class LoginSheetState extends State<LoginSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Wrap(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    icon: const Icon(
                      Icons.close,
                      size: 32,
                    ),
                  ),
                ]),
                // 分割线
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "选择登录方式",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: Image.asset(
                          "assets/images/google.png",
                          height: 40,
                        ),
                      ),
                      onTap: () => {AuthService().signInWithGoogle(context)},
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: Image.asset(
                          "assets/images/apple.png",
                          height: 40,
                        ),
                      ),
                      onTap: () {
                        AuthService().signInWithApple(context);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    // Container(
                    //   padding: const EdgeInsets.all(20),
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.white),
                    //     borderRadius: BorderRadius.circular(16),
                    //     color: Colors.grey[200],
                    //   ),
                    //   child: Image.asset(
                    //     "assets/images/wechat.png",
                    //     height: 40,
                    //   ),
                    // )
                  ],
                ),
                const SizedBox(height: 10),
              ],
            )
          ],
        ),
      ),
    );
  }
}
