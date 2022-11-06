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
      id: fields[3] as int,
      album: fields[0] as String,
      artist: fields[2] as String,
      artUri: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AlbumItemDB obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.album)
      ..writeByte(1)
      ..write(obj.artUri)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.id);
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
