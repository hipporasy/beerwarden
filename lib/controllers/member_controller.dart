import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/member.dart';

class MemberController extends GetxController {
  var members = [].obs;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController beerCrateController = TextEditingController();
  var selectedDate = DateTime.now().obs;
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode beerCrateFocus = FocusNode();

  onInit() {
    try {
      Hive.registerAdapter(MemberAdapter());
    } catch (e) {
      print(e);
    }
    getMembers();
    super.onInit();
  }

  void selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime(2018),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
      // textEditingController.text = DateFormat('DD-MM-
      //     yyyy').format(selectedDate.value).toString();
      // }
    }
  }

  addMember(Member member) async {
    members.add(member);
    var box = await Hive.openBox('db');
    box.put('members', members.toList());
    print("To Do Object added $members");
  }

  Future getMembers() async {
    Box box;
    try {
      box = Hive.box('db');
    } catch (error) {
      box = await Hive.openBox('db');
    }

    var tds = box.get('members');
    if (tds != null) members.value = tds;
  }

  clearMembers() {
    try {
      Hive.deleteBoxFromDisk('db');
    } catch (error) {
      print(error);
    }
    members.value = [];
  }

  deleteMember(Member member) async {
    members.remove(member);
    var box = await Hive.openBox('db');
    box.put('members', members.toList());
  }
}
