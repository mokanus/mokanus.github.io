import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/entities/album_meta.dart';
import 'package:tingfm/values/hive_box.dart';
import 'package:tingfm/values/hive_boxes/album_db.dart';

class HishoryProvider extends ChangeNotifier {
  var historyItems = <AlbumItemDB>[];
  var metas = <String, AlbumMeta>{};

  Future<void> addItem(AlbumItemDB album) async {
    var box = await Hive.openBox<AlbumItemDB>(HiveBoxes.hisotyDB);
    await box.add(album);
    historyItems = box.values.toList();
    notifyListeners();
  }

  Future<void> addItemFromAlbum(AlbumItem album) async {
    var box = await Hive.openBox<AlbumItemDB>(HiveBoxes.hisotyDB);
    var item = album.convertToAlbumItemDB();
    historyItems = box.values.toList();
    bool contain = historyItems.any((element) => element.album == item.album);

    if (!contain) {
      await box.add(item);
    }

    historyItems = box.values.toList().reversed.toList();
    notifyListeners();
  }

  Future<List<AlbumItemDB>> getHistoryItems() async {
    var box = await Hive.openBox<AlbumItemDB>(HiveBoxes.hisotyDB);
    historyItems = box.values.toList();
    notifyListeners();
    return historyItems;
  }

  Future flushHistoryItems() async {
    historyItems.clear();
    metas.clear();

    var box = await Hive.openBox<AlbumItemDB>(HiveBoxes.hisotyDB);
    historyItems = box.values.toList().reversed.toList();

    var metaBox = await Hive.openBox(HiveBoxes.albumMetaDB);
    for (var item in historyItems) {
      var metaData = metaBox.get('album_${item.album}');
      if (metaData != null) {
        metas[item.album] = AlbumMeta.fromJson(metaData.toString());
      }
    }

    notifyListeners();
  }

  Future<void> removeItem(AlbumItemDB item) async {
    var box = await Hive.openBox<AlbumItemDB>(HiveBoxes.hisotyDB);
    await box.delete(item);
    historyItems = box.values.toList();
    notifyListeners();
  }

  Future<void> remove(int index) async {
    var box = await Hive.openBox<AlbumItemDB>(HiveBoxes.hisotyDB);
    var item = historyItems.elementAt(index);
    await box.delete(item.album);
    historyItems = box.values.toList().reversed.toList();
    notifyListeners();
  }

  AlbumMeta? getAlbumMeta(String album) {
    return metas[album];
  }

  String getAlbumMetaInfo(int index) {
    var album = historyItems[index].album;
    if (album != "") {
      return "播放到 : ${metas[album]?.title}";
    }
    return "";
  }
}
