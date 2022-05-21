import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/events.dart';

class EventController extends GetxController {
  var events = [].obs;
  Rx<Events?> happeningEvent = null.obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  var selectedDate = DateTime.now().obs;
  FocusNode titleFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  @override
  onInit() {
    try {
      Hive.registerAdapter(EventsAdapter());
    } catch (e) {
      print(e);
    }
    getEvents();
    super.onInit();
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
      dateController.text =
          DateFormat.yMMMd().format(selectedDate.value).toString();
    }
  }

  Future<bool> addEvent(Events event) async {
    events.add(event);
    var box = await Hive.openBox('db');
    box.put('events', events.toList());
    print("To Do Object added $events");
    return true;
  }

  Future getEvents() async {
    Box box;
    try {
      box = Hive.box('db');
    } catch (error) {
      box = await Hive.openBox('db');
    }

    var tds = box.get('events');
    if (tds != null) events.value = tds;
  }

  clearEvents() {
    try {
      Hive.deleteBoxFromDisk('db');
    } catch (error) {
      print(error);
    }
    events.value = [];
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
  }
}
