import 'package:beerwarden/models/member.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../controllers/member_controller.dart';

class MembersScreen extends StatelessWidget {
  final controller = Get.put(MemberController());

  MembersScreen({Key? key}) : super(key: key);

  void addMember() {
    if (controller.firstNameController.text.isEmpty ||
        controller.lastNameController.text.isEmpty) return;
    var todo = Member(
        id: UniqueKey().toString(),
        firstName: controller.firstNameController.text,
        lastName: controller.lastNameController.text,
        dob: controller.selectedDate.value,
        beerCrate: int.parse(controller.beerCrateController.text));
    controller.addMember(todo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Add Member"),
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
                CustomTextFormField(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  borderRadius: BorderRadius.circular(10),
                  controller: controller.firstNameController,
                  height: 50.0,
                  hintText: "First Name",
                  nextFocus: controller.lastNameFocus,
                ),
                CustomTextFormField(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  focus: controller.lastNameFocus,
                  borderRadius: BorderRadius.circular(10),
                  controller: controller.lastNameController,
                  height: 50.0,
                  hintText: "Last Name",
                  maxLines: 10,
                ),
                GestureDetector(
                  child: Container(
                    height: 48,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Select Date"),
                  ),
                  onTap: () {
                    controller.selectDate();
                  },
                ),
                CustomTextFormField(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  focus: controller.beerCrateFocus,
                  borderRadius: BorderRadius.circular(10),
                  controller: controller.beerCrateController,
                  height: 50.0,
                  hintText: "Number of Beer Crate",
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
          // Divider(),
          // Obx(
          //   () => Text(
          //     "Members (${controller.todos.length})",
          //     style: TextStyle(
          //       fontSize: 22,
          //       fontWeight: FontWeight.w900,
          //     ),
          //   ),
          // ),
          // _buildMembersList(),
        ],
      ),
    );
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
                color: color ?? Theme
                    .of(context)
                    .primaryColor,
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
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final double height;
  final BorderRadius? borderRadius;
  final FocusNode? nextFocus;
  final FocusNode? focus;
  final int? maxLines;
  final EdgeInsets? padding;

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
