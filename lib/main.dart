import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tingfm/pages/app/app.dart';
import 'package:tingfm/providers/classify.dart';
import 'package:tingfm/providers/album_info.dart';
import 'package:tingfm/providers/favorite.dart';
import 'package:tingfm/providers/history.dart';
import 'package:tingfm/providers/recommend.dart';
import 'package:tingfm/providers/search.dart';
import 'package:tingfm/services/audio_service.dart';
import 'package:tingfm/utils/global.dart';
import 'package:tingfm/values/hive_boxes/album_db.dart';
import 'package:provider/provider.dart';

import 'providers/app.dart';
import 'providers/list_by_classify.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Paint.enableDithering = true;

  await setupLocator();
  await startService();
  await Global.init();

  runApp(
    //做灰度处理
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
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

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = dir.path;
    File dbFile = File('$dirPath/$boxName.hive');
    File lockFile = File('$dirPath/$boxName.lock');
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      dbFile = File('$dirPath/tingfm/$boxName.hive');
      lockFile = File('$dirPath/tingfm/$boxName.lock');
    }
    await dbFile.delete();
    await lockFile.delete();
    await Hive.openBox(boxName);
    throw 'Failed to open $boxName Box\nError: $error';
  });
  // clear box if it grows large
  if (limit && box.length > 500) {
    box.clear();
  }
}
