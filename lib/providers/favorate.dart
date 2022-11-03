import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/values/hive_box.dart';
import 'package:tingfm/values/hive_boxs/album_db.dart';

class FavorateProvider extends ChangeNotifier {
  List<AlbumItemDB> favorateItems = <AlbumItemDB>[];

  Future<void> addItem(AlbumItemDB album) async {
    Box<AlbumItemDB> box =
        await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    await box.add(album);
    favorateItems = box.values.toList();
    notifyListeners();
  }

  Future<void> addItemFromAlbum(AlbumItem album) async {
    Box<AlbumItemDB> box =
        await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    var item = album.convertToAlbumItemDB();
    await box.add(item);
    favorateItems = box.values.toList();
    favorateItems = favorateItems.reversed.toList();
    notifyListeners();
  }

  Future<List<AlbumItemDB>> getFavorateItems() async {
    Box<AlbumItemDB> box =
        await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    favorateItems = box.values.toList();
    notifyListeners();
    return favorateItems;
  }

  Future flushFavorateItems() async {
    Box<AlbumItemDB> box =
        await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    favorateItems = box.values.toList();
    favorateItems = favorateItems.reversed.toList();
    notifyListeners();
  }

  Future<void> removeItem(AlbumItemDB item) async {
    Box<AlbumItemDB> box =
        await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    await box.delete(item);
    favorateItems = box.values.toList();
    notifyListeners();
  }
}
