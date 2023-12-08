import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tingfm/firebase_options.dart';
import 'package:tingfm/pages/app/app.dart';
import 'package:tingfm/providers/classify.dart';
import 'package:tingfm/providers/album_info.dart';
import 'package:tingfm/providers/favorite.dart';
import 'package:tingfm/providers/history.dart';
import 'package:tingfm/providers/index.dart';
import 'package:tingfm/providers/recommend.dart';
import 'package:tingfm/providers/search.dart';
import 'package:tingfm/services/audio_service.dart';
import 'package:tingfm/utils/global.dart';
import 'package:tingfm/values/hive_boxes/album_db.dart';
import 'package:provider/provider.dart';

import 'providers/app.dart';
import 'providers/list_by_classify.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setupLocator();
  await startService();
  await Global.init();

  runApp(
    //做灰度处理
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => IndexProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => RecommendProvider()),
        ChangeNotifierProvider(create: (_) => AlbumInfoProvider()),
        ChangeNotifierProvider(create: (_) => ClassifyProvider()),
        ChangeNotifierProvider(create: (_) => ListByClassifyProvider()),
        ChangeNotifierProvider(create: (_) => HishoryProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: const App(),
    ),
  );
}

Future<void> startService() async {
  final AudioPlayerHandler audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandlerImpl(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.mokanu.tingfm',
      androidNotificationChannelName: '听书铺子',
      androidNotificationOngoing: true,
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidShowNotificationBadge: true,
      notificationColor: Colors.grey[900],
    ),
  );
  GetIt.I.registerSingleton<AudioPlayerHandler>(audioHandler);
}

Future setupLocator() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AlbumItemDBAdapter());
}
