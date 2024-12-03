import 'package:dio/dio.dart';
import 'package:fixnow/config/config.dart';
import 'package:fixnow/domain/entities/post.dart';
import 'package:fixnow/domain/mappers/post_mapper.dart';
import 'package:fixnow/infrastructure/errors/custom_error.dart';

class ForumData {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  Future<Post> createPost(
      String username, String title, String content, String time) async {
    try {
      final response = await dio.post('/forum/create/post', data: {
        "username": username,
        "title": title,
        "content": content,
        "time": time
      });

      final post = PostMapper.postJsonToEntity(response.data);
      return post;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw CustomError(e.response?.data['message']);
      }
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message']);
      }

      if (e.response?.statusCode == 404) {
        throw CustomError(e.response?.data['message']);
      }

      if (e.type == DioExceptionType.connectionError) {
        throw CustomError('Revisa tu conexión a internet');
      }
      if (e.response?.statusCode == 500) {
        throw CustomError(
            e.response?.data['message'] ?? 'Error al crear el post');
      }
      throw CustomError('Algo salió mal');
    } catch (e) {
      throw CustomError('Algo pasó');
    }
  }

  // Future<Post> getAllPost(
  //     String username, String title, String content, String time) async {
  //   try {
  //     final response = await dio.post('/forum/create/post', data: {
  //       "username": username,
  //       "title": title,
  //       "content": content,
  //       "time": time
  //     });

  //     final post = PostMapper.postJsonToEntity(response.data);
  //     return post;
  //   } on DioException catch (e) {
  //     if (e.response?.statusCode == 400) {
  //       throw CustomError(e.response?.data['message']);
  //     }
  //     if (e.response?.statusCode == 401) {
  //       throw CustomError(e.response?.data['message']);
  //     }

  //     if (e.response?.statusCode == 404) {
  //       throw CustomError(e.response?.data['message']);
  //     }

  //     if (e.type == DioExceptionType.connectionError) {
  //       throw CustomError('Revisa tu conexión a internet');
  //     }
  //     if (e.response?.statusCode == 500) {
  //       throw CustomError(
  //           e.response?.data['message'] ?? 'Error al crear el post');
  //     }
  //     throw CustomError('Algo salió mal');
  //   } catch (e) {
  //     throw CustomError('Algo pasó');
  //   }
  // }

  // Future<Post> getMyPost(
  //     String username, String title, String content, String time) async {
  //   try {
  //     final response = await dio.post('/forum/create/post', data: {
  //       "username": username,
  //       "title": title,
  //       "content": content,
  //       "time": time
  //     });

  //     final post = PostMapper.postJsonToEntity(response.data);
  //     return post;
  //   } on DioException catch (e) {
  //     if (e.response?.statusCode == 400) {
  //       throw CustomError(e.response?.data['message']);
  //     }
  //     if (e.response?.statusCode == 401) {
  //       throw CustomError(e.response?.data['message']);
  //     }

  //     if (e.response?.statusCode == 404) {
  //       throw CustomError(e.response?.data['message']);
  //     }

  //     if (e.type == DioExceptionType.connectionError) {
  //       throw CustomError('Revisa tu conexión a internet');
  //     }
  //     if (e.response?.statusCode == 500) {
  //       throw CustomError(
  //           e.response?.data['message'] ?? 'Error al crear el post');
  //     }
  //     throw CustomError('Algo salió mal');
  //   } catch (e) {
  //     throw CustomError('Algo pasó');
  //   }
  // }
}
