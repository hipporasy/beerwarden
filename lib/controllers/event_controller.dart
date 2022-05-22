import 'package:beerwarden/common/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/events.dart';
import 'member_controller.dart';
import 'package:timezone/data/latest.dart' as tz;

class EventController extends GetxController {
  final _memberController = Get.put(MemberController());
  final happeningEvent = Rxn<Events>();
  final winnerName = Rxn<String>();
  final isConfirm = Rxn<bool>();

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
    getEvents();
    var box = await Hive.openBox('db');
    DateTime? lastUpdated = box.get("lastUpdated");
    if (lastUpdated == null) {
      await box.put("lastUpdated", DateTime.now());
      await regenerateAllWinners();
    } else {
      if (!lastUpdated.isSameDate(DateTime.now())) {
        await box.put("lastUpdated", DateTime.now());
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

    NotificationService().showNotification((events.length - 1),
        "The winner has been chosen", event.title, event.date);
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
      upcomingEvents.sort((a, b) => b.date.compareTo(a.date));
      var result = values.firstWhereOrNull(
          (element) => (element.date.isSameDate(DateTime.now())));
      if (result != null) {
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
  }

  deleteEvent(Events event) async {
    events.remove(event);
    var box = await Hive.openBox('db');
    box.put('events', events.toList());
    await getEvents();
    NotificationService().flutterLocalNotificationsPlugin.cancelAll();
    for (Events element in upcomingEvents) {
      NotificationService().showNotification((upcomingEvents.length - 1),
          "The winner has been chosen", element.title, element.date);
    }
  }

  regenerateAllWinners() async {
    for (Events element in events) {
      if (element.isConfirmed) {
        continue;
      }
      element.winnerId = _memberController.getRandomMemberId();
    }
    var box = await Hive.openBox('db');
    box.put('events', events.toList());
    getEvents();
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

  generateWinnerName() {
    var winnerId = happeningEvent.value?.winnerId;
    if (winnerId == null) {
      return "";
    }
    isConfirm.value = happeningEvent.value!.isConfirmed;
    winnerName.value = _memberController.getMemberById(winnerId).displayName;
  }

  bool hasMember() {
    return _memberController.members.value.isNotEmpty;
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
