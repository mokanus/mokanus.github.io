// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlbumItemDBAdapter extends TypeAdapter<AlbumItemDB> {
  @override
  final int typeId = 0;

  @override
  AlbumItemDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlbumItemDB(
      id: fields[6] as int,
      album: fields[0] as String,
      artist: fields[2] as String,
      classify: fields[3] as int,
      mediaItems: (fields[9] as List).cast<Media>(),
      artUri: fields[1] as String,
      desc: fields[5] as String,
      count: fields[4] as int,
      listenTimes: fields[7] as int,
      loveCount: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AlbumItemDB obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.album)
      ..writeByte(1)
      ..write(obj.artUri)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.classify)
      ..writeByte(4)
      ..write(obj.count)
      ..writeByte(5)
      ..write(obj.desc)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.listenTimes)
      ..writeByte(8)
      ..write(obj.loveCount)
      ..writeByte(9)
      ..write(obj.mediaItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumItemDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaAdapter extends TypeAdapter<Media> {
  @override
  final int typeId = 0;

  @override
  Media read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Media(
      duration: fields[0] as int,
      title: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Media obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.duration)
      ..writeByte(2)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
