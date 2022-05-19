// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hive/hive.dart';
//
// import '../models/member.dart';
//
// class MemberController extends GetxController {
//   var members = [].obs;
//   var done = [].obs;
//   var remaining = [].obs;
//
//   TextEditingController titleController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   FocusNode titleFocus = FocusNode();
//   FocusNode descriptioinFocus = FocusNode();
//
//   onInit() {
//     try {
//       Hive.registerAdapter(MemberAdapter());
//     } catch (e) {
//       print(e);
//     }
//     getMembers();
//     super.onInit();
//   }
//
//   addMember(Member member) async {
//     members.add(member);
//     var box = await Hive.openBox('db');
//     box.put('members', members.toList());
//     print("To Do Object added $members");
//   }
//
//   Future getMembers() async {
//     Box box;
//     print("Getting members");
//     try {
//       box = Hive.box('db');
//     } catch (error) {
//       box = await Hive.openBox('db');
//       print(error);
//     }
//
//     var tds = box.get('members');
//     print("TODOS $tds");
//     if (tds != null) members.value = tds;
//     for (Member member in members) {
//       if (member.isDone) {
//         done.add(member);
//       } else {
//         remaining.add(member);
//       }
//     }
//   }
//
//   clearMembers() {
//     try {
//       Hive.deleteBoxFromDisk('db');
//     } catch (error) {
//       print(error);
//     }
//     members.value = [];
//   }
//
//   deleteMember(Member member) async {
//     members.remove(member);
//     var box = await Hive.openBox('db');
//     box.put('members', members.toList());
//   }
//
//   toggleMember(Member member) async {
//     var index = members.indexOf(member);
//     var editMember = members[index];
//     editMember.isDone = !editMember.isDone;
//     if (editMember.isDone) {
//       done.add(editMember);
//       remaining.remove(editMember);
//     } else {
//       done.remove(editMember);
//       remaining.add(editMember);
//     }
//     members[index] = editMember;
//     var box = await Hive.openBox('db');
//     box.put('members', members.toList());
//   }
// }
