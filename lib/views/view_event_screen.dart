import 'package:beerwarden/consts/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/event_controller.dart';
import '../models/events.dart';
import 'add_member_screen.dart';

class ViewEventScreen extends StatelessWidget {
  final controller = Get.put(EventController());

  ViewEventScreen({
    Key? key,
    required this.event,
  }) : super(key: key);
  final Events event;

  _onDelete() async {
    await controller.deleteEvent(event);
    Get.back();
  }

  Widget _buildDetail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Date: ",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              DateFormat.yMMMd().format(event.date),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Title: ",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Description: ",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            Flexible(
              child: Text(
                event.description ?? "No Description",
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Member Detail",
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
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
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildDetail(),
          ),
          const SizedBox(height: 20),
          Obx(() {
            var myEvent = controller.getEventById(event.id);
            if (myEvent.manualGenerated) {
              return Text(
                controller.getWinnerName(myEvent),
                style: const TextStyle(color: AppColor.primary, fontSize: 18),
              );
            }
            return const SizedBox();
          }),
          Obx(() {
            var myEvent = controller.getEventById(event.id);
            if (!myEvent.isConfirmed) {
              return OutlinedButton(
                onPressed: () {
                  controller.regenerateWinnerForEvent(event);
                },
                style: OutlinedButton.styleFrom(primary: AppColor.primary),
                child: const Text(
                  'Generate Winner',
                  style: TextStyle(color: AppColor.primary, fontSize: 18),
                ),
              );
            }
            return const SizedBox();
          }),
          const SizedBox(height: 20),
          CustomButton(
            title: "Delete",
            icon: Icons.delete,
            onPressed: () {
              _onDelete();
            },
          )
        ],
      ),
    );
  }
}
