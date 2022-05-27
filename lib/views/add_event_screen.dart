import 'package:beerwarden/consts/app_color.dart';
import 'package:beerwarden/controllers/event_controller.dart';
import 'package:beerwarden/models/events.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatelessWidget {
  final controller = Get.put(EventController());

  AddEventScreen({Key? key}) : super(key: key);

  void addMember() async {
    if (controller.titleController.text.isEmpty) return;
    var event = Events(
        id: UniqueKey().toString(),
        title: controller.titleController.text,
        description: controller.descriptionController.text,
        date: controller.selectedDate.value,
        recurrence: controller.recurrenceTypeValue.value == "NONE"
            ? null
            : controller.recurrenceTypeValue.value);
    var result = await controller.addEvent(event);
    if (result) {
      controller.clearFields();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Add Event"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 40,
              left: 20,
              right: 20,
            ),
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                    height: 48,
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Event Date"),
                        Obx(
                          () => Text(
                            DateFormat.yMMMd()
                                .format(controller.selectedDate.value),
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    controller.selectDate();
                  },
                ),
                Container(
                  height: 48,
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Repeat"),
                      Obx(
                        () => DropdownButton(
                            value: controller.recurrenceTypeValue.value,
                            style: const TextStyle(
                                color: AppColor.primary, fontSize: 18),
                            onChanged: (value) {
                              if (value != null) {
                                controller.recurrenceTypeValue.value =
                                    value.toString();
                              }
                            },
                            items: dropdownItems),
                      ),
                    ],
                  ),
                ),
                CustomTextFormField(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  borderRadius: BorderRadius.circular(10),
                  controller: controller.titleController,
                  height: 50.0,
                  hintText: "Event Name",
                  nextFocus: controller.descriptionFocus,
                  textInputType: TextInputType.name,
                ),
                CustomTextFormField(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  focus: controller.descriptionFocus,
                  borderRadius: BorderRadius.circular(10),
                  controller: controller.descriptionController,
                  height: 120,
                  hintText: "Description",
                  maxLines: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Align(
              alignment: Alignment.center,
              child: CustomButton(
                title: "Add",
                icon: Icons.add,
                onPressed: addMember,
              )),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "NONE", child: Text("None")),
      DropdownMenuItem(
          value: RecurranceType.daily.toString(), child: const Text("Daily")),
      DropdownMenuItem(
          value: RecurranceType.weekly.toString(), child: const Text("Weekly")),
      DropdownMenuItem(
          value: RecurranceType.monthly.toString(),
          child: const Text("Monthly")),
      DropdownMenuItem(
          value: RecurranceType.yearly.toString(), child: const Text("Yearly")),
    ];
    return menuItems;
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.icon,
    this.height = 48.0,
    this.color,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String title;
  final IconData icon;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: color ?? Theme.of(context).primaryColor,
              ),
              child: TextButton.icon(
                onPressed: onPressed,
                icon: Icon(
                  icon,
                  color: Colors.white,
                ),
                label: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.height,
    required this.hintText,
    this.borderRadius,
    this.nextFocus,
    this.focus,
    this.maxLines,
    this.padding,
    this.textInputType,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final double height;
  final BorderRadius? borderRadius;
  final FocusNode? nextFocus;
  final FocusNode? focus;
  final int? maxLines;
  final EdgeInsets? padding;
  final TextInputType? textInputType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
      ),
      child: TextFormField(
        keyboardType: textInputType,
        autofocus: true,
        focusNode: focus,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
        controller: controller,
        onEditingComplete: () {
          nextFocus?.requestFocus();
        },
      ),
    );
  }
}
