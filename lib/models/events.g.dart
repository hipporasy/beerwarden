// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventsAdapter extends TypeAdapter<Events> {
  @override
  final int typeId = 2;

  @override
  Events read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Events(
      id: fields[1] as String,
      date: fields[2] as DateTime,
      title: fields[3] as String,
      description: fields[4] as String?,
      winnerId: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Events obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.winnerId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
