import 'package:beerwarden/consts/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../controllers/member_controller.dart';
import '../models/member.dart';
import 'add_member_screen.dart';

class MemberListScreen extends StatelessWidget {
  final controller = Get.put(MemberController());

  MemberListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigator.of(context).push(MembersScreen())
          Get.to(() => MembersScreen());
        },
        label: Row(
          children: const [
            Icon(Icons.person_add),
            SizedBox(width: 10),
            Text("Add Member"),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 3,
      itemBuilder: (context, index) {
        // Member member = controller.members[index];
        return GestureDetector(
          onTap: () {
            // Get.to(() => ViewMemberScreen(member: member));
          },
          onLongPress: () {
            // controller.toggleMember(member);
          },
          child: MemberCard(
            displayName: "Dy Sborng",
            date: DateTime.now(),
            beerCrate: 5,
          ),
        );
      },
    );
  }
}

class MemberCard extends StatelessWidget {
  const MemberCard({
    Key? key,
    required this.displayName,
    required this.date,
    required this.beerCrate,
  }) : super(key: key);
  final String displayName;
  final DateTime date;
  final int beerCrate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: AppColor.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.date_range,
                      color: AppColor.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      timeago.format(date),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Image.asset("images/beers.png", width: 24, height: 24),
              const SizedBox(width: 5),
              Text(
                beerCrate.toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
