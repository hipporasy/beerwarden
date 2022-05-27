import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:beerwarden/controllers/event_controller.dart';

class AlarmScheduler {
  static final AlarmScheduler _scheduler = AlarmScheduler._internal();

  AlarmScheduler._internal();

  late EventController eventController;

  factory AlarmScheduler() {
    return _scheduler;
  }

  void schedule() async {
    try {
      await AndroidAlarmManager.periodic(const Duration(days: 1), 1, onAlarm(),
          startAt: DateTime(
              DateTime
                  .now()
                  .year, DateTime
              .now()
              .month, DateTime
              .now()
              .day, 1),
          rescheduleOnReboot: true);
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
