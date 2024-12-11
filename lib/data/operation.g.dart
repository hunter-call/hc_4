// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OperationAdapter extends TypeAdapter<Operation> {
  @override
  final int typeId = 0;

  @override
  Operation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Operation(
      topic: fields[2] as String,
      description: fields[5] as String,
      subject: fields[1] as String,
      date: fields[3] as DateTime,
      level: fields[4] as int,
      objective: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Operation obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.objective)
      ..writeByte(1)
      ..write(obj.subject)
      ..writeByte(2)
      ..write(obj.topic)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.level)
      ..writeByte(5)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
