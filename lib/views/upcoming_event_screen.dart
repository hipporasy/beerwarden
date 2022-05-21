import 'package:beerwarden/consts/app_color.dart';
import 'package:beerwarden/controllers/event_controller.dart';
import 'package:beerwarden/views/add_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/events.dart';

class UpcomingEventScreen extends StatelessWidget {
  final controller = Get.put(EventController());

  UpcomingEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.clearFields();
          Get.to(() => AddEventScreen());
        },
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        label: Image.asset(
          "images/add.png",
          width: 24,
          height: 24,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Happening Now",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          _buildHappeningEvent(),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Upcoming Event",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHappeningEvent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 20,
            spreadRadius: 1,
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [Text("data")],
      ),
    );
  }

  Widget _buildList() {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.events.length,
        itemBuilder: (context, index) {
          Events event = controller.events[index];
          return GestureDetector(
            onTap: () {
              // Get.to(() => ViewEventScreen(member: member));
            },
            onLongPress: () {
              // controller.toggleEvent(member);
            },
            child: EventCard(event: event),
          );
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    Key? key,
    required this.event,
  }) : super(key: key);
  final Events event;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      height: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 20,
            spreadRadius: 1,
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.event,
                      color: AppColor.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Text(
                  event.description ?? "No Description",
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: AppColor.primary,
              ),
              const SizedBox(width: 5),
              Text(DateFormat.yMMMEd().format(event.date))
            ],
          ),
        ],
      ),
    );
  }
}
