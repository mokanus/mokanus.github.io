import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tingfm/pages/search/search.dart';
import 'package:tingfm/utils/router.dart';

class TingSearchBar extends StatelessWidget {
  const TingSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: GestureDetector(
          child: Container(
            margin: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(16),
                ScreenUtil().setHeight(5),
                ScreenUtil().setWidth(16),
                ScreenUtil().setHeight(5)),
            height: ScreenUtil().setHeight(120),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      EdgeInsets.fromLTRB(10, 5, ScreenUtil().setWidth(16), 5),
                  child: Icon(
                    Icons.multitrack_audio,
                    color: const Color.fromARGB(255, 234, 78, 94),
                    size: ScreenUtil().setSp(60),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), 5, 20, 5),
                  child: Text(
                    "搜索专辑 / 平凡的世界",
                    style: TextStyle(
                        color: const Color.fromARGB(255, 187, 187, 187),
                        fontSize: ScreenUtil().setSp(45)),
                  ),
                )
              ],
            ),
          ),
          onTap: () =>
              AppRouter.pushPageWithOutAnim(context, const SearchPage()),
        ),
      ),
      GestureDetector(
          child: Icon(
            Ionicons.link_outline,
            color: const Color.fromARGB(255, 234, 78, 94),
            size: ScreenUtil().setSp(84),
          ),
          onTap: () {}),
    ]);
  }
}
