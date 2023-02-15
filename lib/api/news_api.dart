import 'package:dio/dio.dart';
import 'package:terrabayt_uz/data/models/category_data.dart';
import 'package:terrabayt_uz/data/models/news_data.dart';

class NewsApi {
  final Dio _dio;

  NewsApi(this._dio);

  // Future<List<NewsData>> getPosts(int categoryId) async {
  //   final response = await _dio.get("api.php?action=posts&first_update=1613122152&last_update=0&category=$categoryId");
  //   final list = response.data as List;
  //   return list.map((e) => NewsData.fromJson(e)).toList();
  // }



}
