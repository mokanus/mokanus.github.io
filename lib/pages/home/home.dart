import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tingfm/pages/home/classify.dart';
import 'package:tingfm/pages/home/recommend.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        foregroundColor: Colors.black,
        title: Container(
          margin: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(16),
              ScreenUtil().setHeight(5),
              ScreenUtil().setWidth(16),
              ScreenUtil().setHeight(5)),
          height: ScreenUtil().setHeight(120),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 254, 254, 254),
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
                  Icons.search,
                  color: const Color.fromARGB(255, 187, 187, 187),
                  size: ScreenUtil().setSp(60),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), 5, 20, 5),
                child: Text(
                  "隋唐演义",
                  style: TextStyle(
                      color: const Color.fromARGB(255, 187, 187, 187),
                      fontSize: ScreenUtil().setSp(45)),
                ),
              )
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: const Color.fromARGB(255, 234, 78, 94),
          indicatorWeight: 3.0,
          controller: _tabController,
          labelColor: const Color.fromARGB(255, 234, 78, 94),
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: ScreenUtil().setSp(52),
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelColor: Colors.grey,
          unselectedLabelStyle: TextStyle(
            color: Colors.grey,
            fontSize: ScreenUtil().setSp(52),
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(
              child: Text(
                "推荐",
              ),
            ),
            Tab(
              child: Text(
                "分类",
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: const [RecommendView(), ClassifyView()]),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
