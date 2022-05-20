import 'package:hive/hive.dart';
part 'event.g.dart';

@HiveType(typeId: 1)
class Member {
  @HiveField(1)
  String id;
  @HiveField(2)
  DateTime date;
  @HiveField(3)
  String title;
  @HiveField(4)
  String description;


  Member({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
  });

  Member.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        date = json['date'],
        description = json['description'];

  toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
    };
  }
}
