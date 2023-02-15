import 'package:get_it/get_it.dart';

final di = GetIt.instance;

void setUp(){
  di.registerLazySingleton(() => Dio(BaseOptions(baseUrl:"")));
  di.registerLazySingleton(() => NewsApi(di.get<Dio>()));

}