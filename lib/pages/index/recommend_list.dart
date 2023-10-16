import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tingfm/pages/index/recommend_item.dart';
import 'package:tingfm/pages/index/recommend_list_item.dart';

class RecommendListWidget extends StatelessWidget {
  const RecommendListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: Colors.black26),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: ScreenUtil().setHeight(100),
                  width: ScreenUtil().setWidth(16),
                  decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(2))),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(32),
                ),
                const Text(
                  "猜你喜欢",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              height: ScreenUtil().setHeight(80),
              width: ScreenUtil().setWidth(220),
              decoration: BoxDecoration(
                border: const Border.fromBorderSide(
                  BorderSide(color: Colors.black45, width: 0.3),
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "查看更多",
                    style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                  ),
                  const Icon(
                    Icons.arrow_right,
                    color: Colors.black,
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(420),
          child: ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            prototypeItem: RecommendListItemWidget(),
            itemBuilder: (context, index) {
              return RecommendListItemWidget();
            },
          ),
        ),
      ],
    );
  }
}
