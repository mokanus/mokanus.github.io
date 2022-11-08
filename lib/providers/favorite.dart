import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/values/hive_box.dart';
import 'package:tingfm/values/hive_boxes/album_db.dart';

class FavoriteProvider extends ChangeNotifier {
  List<AlbumItemDB> favoriteItems = <AlbumItemDB>[];

  Future<void> addItem(AlbumItemDB album) async {
    Box<AlbumItemDB> box =
        await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    await box.add(album);
    favoriteItems = box.values.toList();
    notifyListeners();
  }

  Future<void> addItemFromAlbum(AlbumItem album) async {
    Box<AlbumItemDB> box =
        await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    var item = album.convertToAlbumItemDB();
    await box.add(item);
    favoriteItems = box.values.toList();
    favoriteItems = favoriteItems.reversed.toList();
    notifyListeners();
  }

  Future<List<AlbumItemDB>> getFavoriteItems() async {
    Box<AlbumItemDB> box =
        await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    favoriteItems = box.values.toList();
    notifyListeners();
    return favoriteItems;
  }

  Future flushFavoriteItems() async {
    Box<AlbumItemDB> box =
        await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    favoriteItems = box.values.toList();
    favoriteItems = favoriteItems.reversed.toList();
    notifyListeners();
  }

  Future<void> removeItem(AlbumItemDB item) async {
    Box<AlbumItemDB> box =
        await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    await box.delete(item);
    favoriteItems = box.values.toList();
    notifyListeners();
  }
}
