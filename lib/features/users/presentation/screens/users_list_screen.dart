// lib/features/users/presentation/screens/users_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../widgets/user_card.dart';
import '../widgets/user_shimmer.dart';
import 'user_detail_screen.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final controller = Get.put(UserController());
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.loadUsers();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        controller.loadUsers(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: Obx(() {
        if (controller.isLoading.value && controller.users.isEmpty) {
          return const UserShimmer();
        }

        if (controller.errorMessage.isNotEmpty && controller.users.isEmpty) {
          return _buildErrorState();
        }

        return RefreshIndicator(
          color: Colors.indigo,
          onRefresh: controller.refreshUsers,
          child: ListView.builder(
            controller: scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount:
            controller.users.length + (controller.isLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.users.length) {
                final user = controller.users[index];
                return AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 400),
                  child: UserCard(
                    user: user,
                    onTap: () => Get.to(
                          () => UserDetailScreen(userId: user.id),
                      transition: Transition.cupertino,
                    ),
                  ),
                );
              } else {
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

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 70, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: controller.refreshUsers,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
