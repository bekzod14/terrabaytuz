import 'package:dio/dio.dart';
import 'package:terrabayt_uz/data/models/category_data.dart';

class NewsApi {
  final Dio _dio;

  NewsApi(this._dio);

  Future<List<CategoryData>> getCategories() async {
    final response =
        await _dio.get("https://www.terabayt.uz/api.php?action=categories");
    print("response: $response");
    print("response: ${response.data}");
    return categoryDataFromMap(response.data as String);
  }
}
