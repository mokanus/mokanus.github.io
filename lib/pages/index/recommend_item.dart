import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tingfm/widgets/image.dart';

class RecommendItemWidget extends StatelessWidget {
  const RecommendItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 图片控件
        Stack(
          children: [
            Container(
              width: ScreenUtil().setWidth(300),
              height: ScreenUtil().setHeight(300),
              padding: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setSp(10), 0),
              child: imageCached(
                "assets/images/banners/3.webp",
                "cachedImage",
                width: ScreenUtil().setWidth(300),
                height: ScreenUtil().setHeight(300),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.play_arrow_outlined,
                      color: Colors.white,
                    ),
                    Text(
                      "100万",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(32),
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(20),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
        //专辑名字
        Text(
          "平凡的世界",
          style: TextStyle(fontSize: ScreenUtil().setSp(40)),
        )
      ],
    );
  }
}
