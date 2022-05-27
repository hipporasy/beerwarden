import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:beerwarden/controllers/event_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmScheduler {
  static const ALARM_KEY = "IS_ALARM_SET";
  static final AlarmScheduler _scheduler = AlarmScheduler._internal();

  AlarmScheduler._internal();

  late EventController eventController;

  factory AlarmScheduler() {
    return _scheduler;
  }

  void schedule() async {
    var instance = await SharedPreferences.getInstance();
    if (!(instance.getBool(ALARM_KEY) ?? false)) {
      return;
    }
    try {
      await AndroidAlarmManager.periodic(const Duration(days: 1), 1, onAlarm(),
          startAt: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day, 1),
          rescheduleOnReboot: true);
      instance.setBool(ALARM_KEY, true);
    } catch (e) {
      print(e);
    }
  }

  onAlarm() async {
    try {
      await eventController.getEvents();
      await eventController.occurrenceIfNeeded();
      await eventController.recurrenceIfNeeded();
    } catch (e) {
      print(e);
    }
  }
}
