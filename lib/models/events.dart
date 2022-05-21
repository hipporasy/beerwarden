import 'package:hive/hive.dart';

part 'events.g.dart';

@HiveType(typeId: 2)
class Events {
  @HiveField(1)
  String id;
  @HiveField(2)
  DateTime date;
  @HiveField(3)
  String title;
  @HiveField(4)
  String? description;
  @HiveField(5)
  String? winnerId;
  @HiveField(6)
  bool isConfirmed;

  Events(
      {required this.id,
      required this.date,
      required this.title,
      this.description,
      this.winnerId,
      this.isConfirmed = false});

  Events.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        date = json['date'],
        description = json['description'],
        winnerId = json['winnerId'],
        isConfirmed = json['isConfirmed'];

  toJson() {
    return {
      'id': id,
      'date': date,
      'title': title,
      'description': description,
      'winnerId': winnerId,
      'isConfirmed': isConfirmed,
    };
  }
}
