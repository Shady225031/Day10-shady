import 'package:dio/dio.dart';

class FirebaseService {
  final Dio _dio = Dio();
  final String baseUrl =
      'https://day10-b215d-default-rtdb.firebaseio.com/';

  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      await _dio.post('$baseUrl/products.json', data: productData);
    } catch (e) {
      print('Error Adding Data:$e');
    }
  }

  Future<Map<String, dynamic>> getProducts() async {
    try {
      final response = await _dio.get('$baseUrl/products.json');
      if (response.statusCode == 200 && response.data != null) {
        print(response.data);
        return Map<String, dynamic>.from(response.data);
      }
    } catch (e) {
      print('Error Getting Data:$e');
    }
    return {};
  }

  Future<void> deleteProductData(String productId) async {
    try {
      await _dio.delete('$baseUrl/products/$productId.json');
    } catch (e) {
      print('Error Deleteing Data:$e');
    }
  }

  Future<void> editProduct(
      String productId, Map<String, dynamic> editProduct) async {
    try {
      await _dio.patch(
        '$baseUrl/products/$productId.json',
        data: editProduct
      );
    } catch (e) {
      print('Error Editing Data:$e');
    }
  }
}