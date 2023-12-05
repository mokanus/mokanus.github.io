import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tingfm/pages/classify/classify.dart';
import 'package:tingfm/pages/recommend/recommend.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  void openRecommendPage(BuildContext ctx) {
    Navigator.of(ctx).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => const RecommendPage(),
      ),
    );
  }

  void openClassifyPage(BuildContext ctx) {
    Navigator.of(ctx).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => const ClassifyPage(),
      ),
    );
  }

  void openRankPage(BuildContext ctx) {
    Navigator.of(ctx).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => const RecommendPage(),
      ),
    );
  }

  void openHotPage(BuildContext ctx) {
    Navigator.of(ctx).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => const RecommendPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return // 菜单组件
        Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () => openRecommendPage(context),
          child: Column(
            children: [
              Container(
                height: ScreenUtil().setHeight(120),
                width: ScreenUtil().setWidth(120),
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(64)),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(28)),
              Text(
                '每日推荐',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(36),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => openClassifyPage(context),
          child: Column(
            children: [
              Container(
                height: ScreenUtil().setHeight(120),
                width: ScreenUtil().setWidth(120),
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(64)),
                child: const Icon(
                  Icons.account_tree_outlined,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(28)),
              Text(
                '专辑分类',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(36),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => openRankPage(context),
          child: Column(
            children: [
              Container(
                height: ScreenUtil().setHeight(120),
                width: ScreenUtil().setWidth(120),
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(64)),
                child: const Icon(
                  Icons.flag_outlined,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(28)),
              Text(
                '排行榜单',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(36),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => openHotPage(context),
          child: Column(
            children: [
              Container(
                height: ScreenUtil().setHeight(120),
                width: ScreenUtil().setWidth(120),
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(64)),
                child: const Icon(
                  Icons.microwave,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(28)),
              Text(
                '热门专辑',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(36),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
