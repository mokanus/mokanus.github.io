import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tingfm/components/search_bar.dart';
import 'package:tingfm/pages/index/menu.dart';
import 'package:tingfm/pages/index/recommend.dart';
import 'package:tingfm/pages/index/recommend_list.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        foregroundColor: Colors.black,
        title: const TingSearchBar(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Column(
              children: [
                // swiper组件
                Container(
                  height: ScreenUtil().setHeight(400),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(64),
                ),
                // 菜单控件
                const MenuWidget(),
                SizedBox(
                  height: ScreenUtil().setHeight(64),
                ),
                // 推荐列表控件
                RecommendListWidget(),
                RecommendWidget(),
                RecommendWidget(),
                RecommendWidget(),
                RecommendListWidget(),
                RecommendWidget(),
                RecommendWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
