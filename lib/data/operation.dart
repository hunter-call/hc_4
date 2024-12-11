import 'package:hive/hive.dart';

part 'operation.g.dart';

@HiveType(typeId: 0)
class Operation extends HiveObject {
  @HiveField(0)
  String objective;

  @HiveField(1)
  String subject;

  @HiveField(2)
  String topic;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  int level;

  @HiveField(5)
  String description;

  Operation(
      {required this.topic,
      required this.description,
      required this.subject,
      required this.date,
      required this.level,
      required this.objective});
}
