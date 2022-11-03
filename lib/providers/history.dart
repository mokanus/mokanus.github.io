import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/values/hive_box.dart';
import 'package:tingfm/values/hive_boxs/album_db.dart';

class HishoryProvider extends ChangeNotifier {
  List<AlbumItemDB> historyItems = <AlbumItemDB>[];

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
    Box<AlbumItemDB> box = await Hive.openBox<AlbumItemDB>(HiveBoxes.hisotyDB);
    historyItems = box.values.toList();
    historyItems = historyItems.reversed.toList();
    notifyListeners();
  }

  Future<void> removeItem(AlbumItemDB item) async {
    Box<AlbumItemDB> box = await Hive.openBox<AlbumItemDB>(HiveBoxes.hisotyDB);
    await box.delete(item);
    historyItems = box.values.toList();
    notifyListeners();
  }
}
