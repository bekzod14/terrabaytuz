import 'package:dio/dio.dart';
import 'package:terrabayt_uz/data/models/category_data.dart';
import 'package:terrabayt_uz/data/models/news_data.dart';

class NewsApi {
  final Dio _dio;

  NewsApi(this._dio);

  Future<List<CategoryData>> getCategories() async {
    final response = await _dio.get("api.php?action=categories");
    print("response: $response");
    print("response: ${response.data}");
    return categoryDataFromMap(response.data as String);
  }

  Future<List<NewsData>> getPost(int categoryId) async {
    final respose = await _dio.get(
        "api.php?action=posts&first_update=1613122152&last_update=0&category=$categoryId");
    return newsDataFromMap(respose.data as String);
  }
}
