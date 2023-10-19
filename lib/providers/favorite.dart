import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/values/hive_box.dart';
import 'package:tingfm/values/hive_boxes/album_db.dart';

class FavoriteProvider extends ChangeNotifier {
  var favoriteItems = <AlbumItemDB>[];

  Future<void> addItem(AlbumItemDB album) async {
    Box<AlbumItemDB> box =
        await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    await box.add(album);
    favoriteItems = box.values.toList();
    notifyListeners();
  }

  Future<bool> addItemFromAlbum(AlbumItem album) async {
    var box = await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    var item = album.convertToAlbumItemDB();

    var allFavorites = box.keys;
    if (allFavorites.length >= 10) {
      await box.deleteAt(0);
    }

    var contain = allFavorites.any((element) => element == album.album);

    if (!contain) {
      await box.put(album.album, item);
    } else {
      await box.delete(album.album);
    }

    favoriteItems = box.values.toList().reversed.toList();
    notifyListeners();

    return contain;
  }

  Future<void> getFavoriteItems() async {
    Box<AlbumItemDB> box =
        await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    favoriteItems = box.values.toList().reversed.toList();
    notifyListeners();
  }

  Future flushFavoriteItems() async {
    Box<AlbumItemDB> box =
        await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    favoriteItems = box.values.toList().reversed.toList();
    notifyListeners();
  }

  Future<void> remove(int index) async {
    var box = await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    var item = favoriteItems.elementAt(index);
    await box.delete(item.album);
    favoriteItems = box.values.toList().reversed.toList();
    notifyListeners();
  }

  Future<AlbumItemDB?> getFavorateItembyName(String name) async {
    var box = await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    var items = box.values.toList();
    return items.firstWhere((element) => element.album == name);
  }
}
