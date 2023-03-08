import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tingfm/utils/global.dart';

enum RewardAdType {
  home,
  player,
  my,
}

class AdmobAdManager {
  RewardedAd? _rewardedAd;
  bool adLoaded = false;

  void loadAd(RewardAdType adType) {
    RewardedAd.load(
        adUnitId: getRewardAdId(adType),
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

  void showAd(RewardAdType adType) {
    if (adLoaded) {
      _rewardedAd?.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
        // ignore: avoid_print
        print('Reward amount: ${rewardItem.amount}');
        adLoaded = false;
      });
    } else {
      loadAd(adType);
    }
  }

  String getRewardAdId(RewardAdType adType) {
    if (!Global.isRelease) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313';
    }

    switch (adType) {
      case RewardAdType.home:
        {
          return 'ca-app-pub-8167720150162612/1292409480';
        }
      case RewardAdType.player:
        {
          return 'ca-app-pub-8167720150162612/8238211345';
        }
      case RewardAdType.my:
        {
          return 'ca-app-pub-8167720150162612/9446247589';
        }
    }
  }

  void dispose() {
    _rewardedAd?.dispose();
  }
}
