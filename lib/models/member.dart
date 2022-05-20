import 'package:hive/hive.dart';

part 'member.g.dart';

@HiveType(typeId: 1)
class Member {
  @HiveField(1)
  String id;
  @HiveField(2)
  String firstName;
  @HiveField(3)
  String lastName;
  @HiveField(4)
  DateTime dob;
  @HiveField(5)
  int beerCrate;

  Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.beerCrate,
  });

  Member.fromJson(Map json)
      : id = json['id'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        dob = json['dob'],
        beerCrate = json['beerCrate'];

  toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'beerCrate': beerCrate,
    };
  }

  String get displayName {
    return "$firstName $lastName";
  }
}
