import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tingfm/pages/broadcast/broaded.dart';
import 'package:tingfm/pages/broadcast/favorate.dart';

class BroadcastPage extends StatefulWidget {
  const BroadcastPage({super.key});

  @override
  State<BroadcastPage> createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                "收听",
              ),
            ),
            Tab(
              child: Text(
                "订阅",
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: const [
        BroadedView(),
        FavorateView(),
      ]),
    );
  }
}
