import 'package:beerwarden/consts/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/member_controller.dart';
import 'add_member_screen.dart';

class ViewMemberScreen extends StatelessWidget {
  final controller = Get.put(MemberController());

  ViewMemberScreen({
    Key? key,
    required this.memberId,
  }) : super(key: key);
  final String memberId;

  _onDelete() async {
    await controller.deleteMember(memberId);
    Get.back();
  }

  Widget _buildDetail() {
    return Obx(
      () {
        var member = controller.getMemberById(memberId);
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "First Name: ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  member.firstName,
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
                  "Last Name: ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  member.lastName,
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
                  "Date of Birth: ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  DateFormat.yMMMd().format(member.dob),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Beer Crate: ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  member.beerCrate.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          var member = controller.getMemberById(memberId);
          member.beerCrate += 1;
          controller.updateMember(member);
        },
        backgroundColor: AppColor.primary,
        label: const Icon(Icons.add),
      ),
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
          CustomButton(
            title: "Edit",
            icon: Icons.edit,
            onPressed: () {
              Get.to(MembersScreen(member: controller.getMemberById(memberId)));
            },
          ),
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
