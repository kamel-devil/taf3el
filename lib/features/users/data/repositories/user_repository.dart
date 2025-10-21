// lib/features/users/data/repositories/user_repository.dart
import 'package:dio/dio.dart';
import '../models/user_model.dart';

class UserRepository {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<UserModel>> fetchUsers({int page = 1}) async {
    try {
      final response = await _dio.get('https://reqres.in/api/users?page=$page');
      final List data = response.data['data'];
      return data.map((e) => UserModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Unexpected error occurred';
    }
  }

  Future<UserModel> fetchUserById(int userId) async {
    try {
      final response = await _dio.get('https://reqres.in/api/users/$userId');
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Unexpected error occurred';
    }
  }

  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timed out. Please check your internet.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'Server took too long to respond.';
    } else if (e.type == DioExceptionType.badResponse) {
      final status = e.response?.statusCode ?? 0;
      switch (status) {
        case 400:
          return 'Invalid request. Please try again.';
        case 401:
          return 'Unauthorized access. Please try again later.';
        case 404:
          return 'User not found.';
        case 500:
          return 'Server error. Please try again later.';
        default:
          return 'Unexpected server error (code: $status).';
      }
    } else if (e.type == DioExceptionType.unknown) {
      return 'Network error. Please check your internet connection.';
    }
    return 'Something went wrong. Please try again.';
  }
}
