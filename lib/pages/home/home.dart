import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:tingfm/pages/home/classify.dart';
import 'package:tingfm/pages/home/recommend.dart';
import 'package:tingfm/pages/search/search.dart';
import 'package:tingfm/utils/router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late TabController _tabController;

  RewardedAd? _rewardedAd;
  bool adLoaded = false;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  void _loadAd() {
    RewardedAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              onAdClicked: (ad) {});
          _rewardedAd = ad;
          adLoaded = true;
        }, onAdFailedToLoad: (LoadAdError error) {
          // ignore: avoid_print
          print('RewardedAd failed to load: $error');
        }));
  }

  void showAd() {
    if (adLoaded) {
      _rewardedAd?.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
        // ignore: avoid_print
        print('Reward amount: ${rewardItem.amount}');
      });
    } else {
      _loadAd();
    }
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        foregroundColor: Colors.black,
        title: Row(children: [
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
                      padding: EdgeInsets.fromLTRB(
                          10, 5, ScreenUtil().setWidth(16), 5),
                      child: Icon(
                        Icons.multitrack_audio,
                        color: const Color.fromARGB(255, 234, 78, 94),
                        size: ScreenUtil().setSp(60),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(16), 5, 20, 5),
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
              onTap: () => AppRouter.pushPageWithOutAnim(
                  context as BuildContext, const SearchPage()),
            ),
          ),
          GestureDetector(
            child: Icon(
              Icons.wifi_tethering_error_rounded,
              color: const Color.fromARGB(255, 234, 78, 94),
              size: ScreenUtil().setSp(84),
            ),
            onTap: () {
              showAd();
              PanaraInfoDialog.show(
                this.context,
                title: "标题弹窗",
                message: "看广告可以获得30分钟的免费听书时长哦",
                buttonText: "好的",
                onTapDismiss: () {
                  Navigator.pop(this.context);
                },
                panaraDialogType: PanaraDialogType.normal,
                barrierDismissible:
                    false, // optional parameter (default is true)
              );
            },
          ),
        ]),
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
    // _rewardedAd?.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
