import 'dart:math';

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

  Member getMemberById(String id) {
    return members.firstWhere((element) => element.id == id);
  }

  @override
  onInit() {
    try {
      Hive.registerAdapter(MemberAdapter());
    } catch (e) {
      print(e);
    }
    getMembers();
    super.onInit();
  }

  setInitialValue(Member member) {
    firstNameController.text = member.firstName;
    lastNameController.text = member.lastName;
    beerCrateController.text = member.beerCrate.toString();
    selectedDate.value = member.dob;
  }

  void selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
    }
  }

  Future<bool> addMember(Member member) async {
    members.add(member);
    var box = await Hive.openBox('db');
    box.put('members', members.toList());
    print("To Do Object added $members");
    return true;
  }

  Future<bool> updateMember(Member member) async {
    members.removeWhere((element) => element.id == member.id);
    members.add(member);
    var box = await Hive.openBox('db');
    box.put('members', members.toList());
    print("To Do Object added $members");
    return true;
  }

   updateBeer(String memberId) async {
    Member? member = members.firstWhereOrNull((element) => element.id == memberId);
    if (member == null) {
      return;
    }
    member.beerCrate -= 1;
    updateMember(member);
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

  clearFields() {
    firstNameController.text = "";
    lastNameController.text = "";
    beerCrateController.text = "";
    selectedDate = DateTime.now().obs;
  }

  deleteMember(String memberId) async {
    members.remove(getMemberById(memberId));
    var box = await Hive.openBox('db');
    box.put('members', members.toList());
  }

  String? getRandomMemberId() {
    List<String> ids = [];
    List<Member> currentMember = members.value.cast();
    for (Member element in currentMember) {
      var duplicatedIds = Iterable.generate(element.beerCrate).toList().map((e) => element.id);
      ids.addAll(duplicatedIds);
    }
    ids.shuffle();
    final random = Random();
    var selectedId = ids[random.nextInt(ids.length)];
    return selectedId;
  }

}
