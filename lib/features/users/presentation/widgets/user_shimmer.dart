// lib/features/users/presentation/widgets/user_shimmer.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserShimmer extends StatelessWidget {
  const UserShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ListTile(
            leading: const CircleAvatar(radius: 25, backgroundColor: Colors.white),
            title: Container(height: 10, width: 100, color: Colors.white),
            subtitle: Container(height: 10, width: 150, color: Colors.white),
          ),
        );
      },
    );
  }
}
