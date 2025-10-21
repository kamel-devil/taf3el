// lib/features/users/presentation/screens/users_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../widgets/user_card.dart';
import '../widgets/user_shimmer.dart';
import 'user_detail_screen.dart';

class UsersListScreen extends StatelessWidget {
  final controller = Get.put(UserController());

  UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        controller.loadUsers(loadMore: true);
      }
    });

    controller.loadUsers();

    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: Obx(() {
        if (controller.isLoading.value && controller.users.isEmpty) {
          return const UserShimmer();
        }

        if (controller.errorMessage.isNotEmpty && controller.users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
                const SizedBox(height: 10),
                Text(controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.refreshUsers,
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshUsers,
          child: ListView.builder(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.users.length +
                (controller.isLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.users.length) {
                final user = controller.users[index];
                return UserCard(
                  user: user,
                  onTap: () => Get.to(() => UserDetailScreen(userId: user.id)),
                );
              } else {
                // loader for pagination
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        );
      }),
    );
  }
}
