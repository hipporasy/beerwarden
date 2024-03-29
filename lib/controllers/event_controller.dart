import 'dart:io';
import 'dart:math';

import 'package:beerwarden/common/notification_service.dart';
import 'package:beerwarden/models/member.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/events.dart';
import 'member_controller.dart';

class EventController extends GetxController {
  final _memberController = Get.put(MemberController());
  final happeningEvent = Rxn<Events>();
  final winnerName = Rxn<String>();
  final isConfirm = Rxn<bool>();
  final recurrenceTypeValue = "NONE".obs;

  late SharedPreferences prefs;
  var events = [].obs;
  var upcomingEvents = [].obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  var selectedDate = DateTime.now().obs;
  FocusNode titleFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  @override
  onInit() async {
    try {
      Hive.registerAdapter(EventsAdapter());
    } catch (e) {
      print(e);
    }
    await getEvents();
    var box = await Hive.openBox('db');
    DateTime? lastUpdated = box.get("lastUpdated");
    if (lastUpdated == null) {
      await box.put("lastUpdated", DateTime.now());
      await birthdayOccurIfNeeded();
      await getEvents();
      await occurrenceIfNeeded();
      await recurrenceIfNeeded();
      await regenerateAllWinners();
    } else {
      if (!lastUpdated.isSameDate(DateTime.now())) {
        await box.put("lastUpdated", DateTime.now());
        await birthdayOccurIfNeeded();
        await getEvents();
        await occurrenceIfNeeded();
        await recurrenceIfNeeded();
        await regenerateAllWinners();
      }
    }
    super.onInit();
  }

  void selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
      dateController.text =
          DateFormat.yMMMd().format(selectedDate.value).toString();
    }
  }

  Future<bool> addEvent(Events event) async {
    event.winnerId = _memberController.getRandomMemberId();
    events.add(event);
    var box = await Hive.openBox('db');
    box.put('events', events.toList());
    if (event.date.isSameDate(DateTime.now())) {
      NotificationService().showNowNotification(
          (events.length - 1),
          "The winner has been chosen for name: ${_memberController.getMemberById(event.winnerId!).displayName}",
          event.title);
    } else {
      NotificationService().showNotification(
          (events.length - 1),
          "The winner has been chosen for name: ${_memberController.getMemberById(event.winnerId!).displayName}",
          event.title,
          event.date);
    }
    getEvents();
    return true;
  }

  Future getEvents() async {
    Box box;
    try {
      box = Hive.box('db');
    } catch (error) {
      box = await Hive.openBox('db');
    }
    List<Events>? values = box.get('events')?.cast<Events>();
    if (values != null) {
      List<Events> allEvents = [...values];
      events.value = [...values];
      upcomingEvents.value =
          allEvents.where((element) => !element.isConfirmed).toList();
      upcomingEvents.sort((a, b) => a.date.compareTo(b.date));
      var result = values.firstWhereOrNull(
          (element) => (element.date.isSameDate(DateTime.now())));
      if (result != null && hasMember()) {
        happeningEvent.value = result;
        generateWinnerName();
        upcomingEvents.remove(result);
      } else {
        happeningEvent.value = null;
      }
    }
  }

  confirmWinner() {
    var e = happeningEvent.value;
    if (e == null) {
      return;
    }
    e.isConfirmed = true;
    e.occurrences = [e.date];
    updateEvent(e);
    _memberController.updateBeer(happeningEvent.value!.winnerId!);
  }

  Future<bool> updateEvent(Events event) async {
    events.removeWhere((element) => element.id == event.id);
    events.add(event);
    var box = await Hive.openBox('db');
    box.put('events', events.toList());
    getEvents();
    return true;
  }

  clearFields() {
    titleController.text = "";
    descriptionController.text = "";
    dateController.text = "";
    selectedDate = DateTime.now().obs;
    dateController.text = "";
    recurrenceTypeValue.value == "NONE";
  }

  deleteEvent(Events event) async {
    if (event == happeningEvent.value) {
      isConfirm.value = false;
    }
    events.remove(event);
    var box = await Hive.openBox('db');
    box.put('events', events.toList());
    await getEvents();
    requeueAllNotification();
  }

  regenerateAllWinners() async {
    for (Events element in events) {
      if (element.isConfirmed ||
          element.manualGenerated ||
          element.date.isAboutToHappen()) {
        continue;
      }
      element.winnerId = _memberController.getRandomMemberId();
    }
    var box = await Hive.openBox('db');
    box.put('events', events.toList());
    getEvents();
    requeueAllNotification();
    return true;
  }

  regenerateWinner() {
    if (happeningEvent.value != null) {
      Events current = happeningEvent.value!;
      current.winnerId = _memberController.getRandomMemberId();
      updateEvent(current);
      happeningEvent.value = current;
      generateWinnerName();
      getEvents();
    }
  }

  Events getEventById(String id) {
    return events.firstWhere((element) => element.id == id);
  }

  String getWinnerName(Events events) {
    return _memberController.getMemberById(events.winnerId!).displayName;
  }

  regenerateWinnerForEvent(Events current) {
    current.winnerId = _memberController.getRandomMemberId();
    current.manualGenerated = true;
    var index = events.indexWhere((element) => current.id == element.id);
    NotificationService().flutterLocalNotificationsPlugin.cancel(index);
    if (!current.date.isSameDate(DateTime.now()) &&
        !current.date.isTomorrow()) {
      NotificationService().showNotification(
          index,
          "The winner has been chosen for name: ${_memberController.getMemberById(current.winnerId!).displayName}",
          current.title,
          current.date);
    }
    updateEvent(current);
  }

  generateWinnerName() {
    var winnerId = happeningEvent.value?.winnerId;
    if (winnerId == null) {
      return "";
    }
    isConfirm.value = happeningEvent.value!.isConfirmed;
    winnerName.value = _memberController.getMemberById(winnerId).displayName;
  }

  bool hasMember() {
    if (_memberController.members.value.isEmpty) {
      return false;
    }
    int crateCount = 0;
    for (Member member in _memberController.members.value) {
      crateCount += member.beerCrate;
    }
    return crateCount > 0;
  }

  occurrenceIfNeeded() async {
    var e = happeningEvent.value;
    if (e == null) {
      return;
    }
    e.occurrences = [e.date];
    updateEvent(e);
  }

  birthdayOccurIfNeeded() {
    _memberController.addBeerIfNeeded();
  }

  recurrenceIfNeeded() async {
    for (Events element in events) {
      if (element.isConfirmed && element.recurrence == null) {
        continue;
      }
      // Reschedule Recurring Events
      if (element.date.isBefore(DateTime.now()) &&
          !element.date.isSameDate(DateTime.now())) {
        DateTime lastOccurrence = element.occurrences?.last ?? DateTime.now();
        element.isConfirmed = false;
        switch (element.recurrence) {
          case RecurranceType.daily:
            element.date = element.date.add(const Duration(days: 1));
            break;
          case RecurranceType.weekly:
            element.date = DateTime(lastOccurrence.year, lastOccurrence.month,
                lastOccurrence.day + 7);
            break;
          case RecurranceType.monthly:
            element.date = DateTime(lastOccurrence.year,
                lastOccurrence.month + 1, lastOccurrence.day);
            break;
          case RecurranceType.yearly:
            element.date = DateTime(lastOccurrence.year + 1,
                lastOccurrence.month, lastOccurrence.day);
            break;
        }
      }
      element.winnerId = _memberController.getRandomMemberId();
    }
    var box = await Hive.openBox('db');
    box.put('events', events.toList());
    await getEvents();
  }

  requeueAllNotification() {
    NotificationService().flutterLocalNotificationsPlugin.cancelAll();
    for (Events element in upcomingEvents) {
      if (element.date.isTomorrow()) {
        continue;
      }
      NotificationService().showNotification(
          (events.length - 1),
          "The winner has been chosen for name: ${_memberController.getMemberById(element.winnerId!).displayName}",
          element.title,
          element.date);
    }
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isBirthday() {
    var other = DateTime.now();
    return month == other.month && day == other.day;
  }

  bool isTomorrow() {
    var other = DateTime.now().add(const Duration(days: 1));
    return month == other.month && day == other.day;
  }

  bool isAboutToHappen() {
    return isTomorrow() ||
        isSameDate(DateTime.now()) ||
        isSameDate(DateTime.now().add(const Duration(days: 2)));
  }
}
