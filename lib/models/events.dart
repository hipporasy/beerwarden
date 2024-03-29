import 'package:hive/hive.dart';

part 'events.g.dart';

class RecurranceType {
  static const daily = "DAILY";
  static const weekly = "WEEKLY";
  static const monthly = "MONTHLY";
  static const yearly = "YEARLY";
}

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
  @HiveField(7)
  String? recurrence;
  @HiveField(8)
  List<DateTime>? occurrences;
  @HiveField(9)
  bool manualGenerated;

  Events(
      {required this.id,
      required this.date,
      required this.title,
      this.description,
      this.winnerId,
      this.isConfirmed = false,
      this.recurrence,
      this.occurrences,
      this.manualGenerated = false});

  Events.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        date = json['date'],
        description = json['description'],
        winnerId = json['winnerId'],
        isConfirmed = json['isConfirmed'],
        recurrence = json['recurrence'],
        occurrences = json['occurrences'],
        manualGenerated = json['manualGenerated'];

  toJson() {
    return {
      'id': id,
      'date': date,
      'title': title,
      'description': description,
      'winnerId': winnerId,
      'isConfirmed': isConfirmed,
      'recurrence': recurrence,
      'occurrences': occurrences,
      'manualGenerated': manualGenerated
    };
  }
}
