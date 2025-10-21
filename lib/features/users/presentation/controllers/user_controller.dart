// lib/features/users/presentation/controllers/user_controller.dart
import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class UserController extends GetxController {
  final UserRepository _repo = UserRepository();

  var users = <UserModel>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  var isLastPage = false.obs;
  var errorMessage = ''.obs;

  Future<void> loadUsers({bool loadMore = false}) async {
    if (isLoading.value || (isLastPage.value && loadMore)) return;

    isLoading.value = true;
    errorMessage.value = '';

    if (!loadMore) {
      users.clear();
      currentPage.value = 1;
      isLastPage.value = false;
    }

    try {
      final fetchedUsers = await _repo.fetchUsers(page: currentPage.value);
      if (fetchedUsers.isEmpty) {
        isLastPage.value = true;
      } else {
        users.addAll(fetchedUsers);
        currentPage.value++;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load users: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshUsers() async {
    await loadUsers(loadMore: false);
  }
}
