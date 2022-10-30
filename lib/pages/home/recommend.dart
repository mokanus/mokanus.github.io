import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/providers/recommend.dart';
import 'package:tingfm/widgets/body_builder.dart';
import 'package:tingfm/widgets/recommend_item.dart';

class RecommendView extends StatefulWidget {
  const RecommendView({super.key});

  @override
  State<RecommendView> createState() => _RecommendViewState();
}

class _RecommendViewState extends State<RecommendView>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<RecommendProvider>(context, listen: false)
          .getRecommendData(context, 0, 10),
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecommendProvider>(builder: (BuildContext context,
        RecommendProvider recommendProvider, Widget? child) {
      return BodyBuilder(
        apiRequestStatus: recommendProvider.apiRequestStatus,
        reload: () => recommendProvider.getRecommendData(context, 0, 10),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          itemCount: recommendProvider.recommendAlbumnList.length ~/ 2,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(55),
                  ScreenUtil().setHeight(5),
                  ScreenUtil().setWidth(55),
                  ScreenUtil().setHeight(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RecommendItem(
                    albumItem: recommendProvider.recommendAlbumnList[index * 2],
                  ),
                  RecommendItem(
                    albumItem:
                        recommendProvider.recommendAlbumnList[index * 2 + 1],
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
