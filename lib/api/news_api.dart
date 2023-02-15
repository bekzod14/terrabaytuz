import 'package:dio/dio.dart';
import 'package:terrabayt_uz/data/models/category_data.dart';
import 'package:terrabayt_uz/data/models/news_data.dart';

class NewsApi {
  final Dio _dio;

  NewsApi(this._dio);

  Future<List<CategoryData>> getCategories() async {
    final response =
        await _dio.get("api.php", queryParameters: {"action": "categories"});
    return categoryDataFromMap(response.data as String);
  }

  Future<List<NewsData>> getPost(int categoryId, int time) async {
    final response = await _dio.get("api.php", queryParameters: {
      "action": "post",
      "first_update": time,
      "category": categoryId
    });
    return newsDataFromMap(response.data as String);
  }
}
