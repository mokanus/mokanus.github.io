import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/entities/album_meta.dart';
import 'package:tingfm/values/hive_box.dart';
import 'package:tingfm/values/hive_boxes/album_db.dart';

class HishoryProvider extends ChangeNotifier {
  List<AlbumItemDB> historyItems = <AlbumItemDB>[];
  Map<String, AlbumMeta> metas = <String, AlbumMeta>{};

  Future<void> addItem(AlbumItemDB album) async {
    Box<AlbumItemDB> box = await Hive.openBox<AlbumItemDB>(HiveBoxes.hisotyDB);
    await box.add(album);
    historyItems = box.values.toList();
    notifyListeners();
  }

  Future<void> addItemFromAlbum(AlbumItem album) async {
    Box<AlbumItemDB> box = await Hive.openBox<AlbumItemDB>(HiveBoxes.hisotyDB);
    var item = album.convertToAlbumItemDB();
    await box.add(item);
    historyItems = box.values.toList();
    historyItems = historyItems.reversed.toList();
    notifyListeners();
  }

  Future<List<AlbumItemDB>> getHistoryItems() async {
    Box<AlbumItemDB> box = await Hive.openBox<AlbumItemDB>(HiveBoxes.hisotyDB);
    historyItems = box.values.toList();
    notifyListeners();
    return historyItems;
  }

  Future flushHistoryItems() async {
    historyItems.clear();
    metas.clear();

    Box<AlbumItemDB> box = await Hive.openBox<AlbumItemDB>(HiveBoxes.hisotyDB);
    historyItems = box.values.toList();
    historyItems = historyItems.reversed.toList();

    var metaBox = await Hive.openBox(HiveBoxes.albumMetaDB);
    for (var item in historyItems) {
      var metaData = metaBox.get('album_${item.album}');
      if (metaData != null) {
        metas[item.album] = fromJson(metaData.toString());
      }
    }

    notifyListeners();
  }

  AlbumMeta? getAlbumMeta(String album) {
    return metas[album];
  }

  Future<void> removeItem(AlbumItemDB item) async {
    Box<AlbumItemDB> box = await Hive.openBox<AlbumItemDB>(HiveBoxes.hisotyDB);
    await box.delete(item);
    historyItems = box.values.toList();
    notifyListeners();
  }
}
