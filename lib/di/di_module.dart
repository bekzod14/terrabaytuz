import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:terrabayt_uz/api/news_api.dart';

final di = GetIt.instance;

void setUp(){
  di.registerLazySingleton(() => Dio(BaseOptions(baseUrl:"")));
  di.registerLazySingleton(() => NewsApi(di.get<Dio>()));

}