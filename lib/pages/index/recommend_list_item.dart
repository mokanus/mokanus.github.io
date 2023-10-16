import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tingfm/widgets/image.dart';

class RecommendListItemWidget extends StatelessWidget {
  const RecommendListItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth * 0.75,
      child: Column(
        children: [
          // 图片控件
          ItemWidget(),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          ItemWidget(),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          ItemWidget(),
        ],
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //专辑名字
        Row(
          children: [
            imageCached("assets/images/banners/3.webp", "cachedKey",
                width: ScreenUtil().setWidth(130),
                height: ScreenUtil().setHeight(130)),
            SizedBox(
              width: ScreenUtil().setWidth(20),
            ),
            Text(
              "平凡的世界",
              style: TextStyle(fontSize: ScreenUtil().setSp(40)),
            ),
            Text(
              "- 杨晨、张震",
              style: TextStyle(fontSize: ScreenUtil().setSp(32)),
            )
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.play_circle,
              color: Colors.red,
            ),
            SizedBox(
              width: ScreenUtil().setWidth(30),
            ),
          ],
        )
      ],
    );
  }
}
