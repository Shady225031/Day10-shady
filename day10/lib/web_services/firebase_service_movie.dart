import 'package:dio/dio.dart';

class FirebaseService {
  final Dio _dio = Dio();
  final String baseUrl =
      'https://day10-b215d-default-rtdb.firebaseio.com/';

  Future<void> addMovie(Map<String, dynamic> movieData) async {
    try {
      await _dio.post('$baseUrl/movies.json', data: movieData);
    } catch (e) {
      print('Error Adding Movie: $e');
    }
  }

  Future<Map<String, dynamic>> getMovies() async {
    try {
      final response = await _dio.get('$baseUrl/movies.json');
      if (response.statusCode == 200 && response.data != null) {
        print(response.data);
        return Map<String, dynamic>.from(response.data);
      }
    } catch (e) {
      print('Error Getting Movies: $e');
    }
    return {};
  }

  Future<void> deleteMovieData(String movieId) async {
    try {
      await _dio.delete('$baseUrl/movies/$movieId.json');
    } catch (e) {
      print('Error Deleting Movie: $e');
    }
  }

  Future<void> editMovie(
      String movieId, Map<String, dynamic> editMovie) async {
    try {
      await _dio.patch(
        '$baseUrl/movies/$movieId.json',
        data: editMovie,
      );
    } catch (e) {
      print('Error Editing Movie: $e');
    }
  }
}
