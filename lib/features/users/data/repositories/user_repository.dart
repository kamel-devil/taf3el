// lib/features/users/data/repositories/user_repository.dart
import 'package:dio/dio.dart';
import '../models/user_model.dart';

class UserRepository {
  final Dio _dio = Dio();

  Future<List<UserModel>> fetchUsers({int page = 1}) async {
    final response = await _dio.get('https://reqres.in/api/users?page=$page');
    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<UserModel> fetchUserById(int userId) async {
    final response = await _dio.get('https://reqres.in/api/users/$userId');
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
