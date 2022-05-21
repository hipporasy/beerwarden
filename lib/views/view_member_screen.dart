import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/member.dart';

class ViewMemberScreen extends StatelessWidget {
  const ViewMemberScreen({
    Key? key,
    required this.member,
  }) : super(key: key);
  final Member member;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          member.displayName,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "First Name: ",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      member.firstName,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Last Name: "),
                    Text(member.lastName),
                  ],
                ),
                Row(
                  children: [
                    const Text("Date of Birth: "),
                    Text(
                      timeago.format(member.dob),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
