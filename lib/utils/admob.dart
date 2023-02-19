import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobManager {
  final BannerAd myBanner = BannerAd(
      adUnitId: '<ad unit ID>',
      size: const AdSize(height: 300, width: 50),
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
        onAdOpened: (Ad ad) => print('Ad opened.'),
        onAdClosed: (Ad ad) => print('Ad closed.'),
        onAdImpression: (Ad ad) => print('Ad impression.'),
      ));

  void loadBanner() {
    myBanner.load();
  }

  // void loadReward() {
  //   RewardedAd.load(
  //       adUnitId: '<test id or account id>',
  //       request: AdRequest(),
  //       rewardedAdLoadCallback: RewardedAdLoadCallback(
  //         onAdLoaded: (RewardedAd ad) {
  //           print('$ad loaded.');
  //           // Keep a reference to the ad so you can show it later.
  //           this._rewardedAd = ad;
  //         },
  //         onAdFailedToLoad: (LoadAdError error) {
  //           print('RewardedAd failed to load: $error');
  //         },
  //       ));
  // }
}
