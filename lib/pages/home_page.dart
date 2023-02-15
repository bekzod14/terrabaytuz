import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:terrabayt_uz/api/news_api.dart';
import 'package:terrabayt_uz/app/app_colors.dart';
import 'package:terrabayt_uz/data/models/category_data.dart';
import 'package:terrabayt_uz/di/di_module.dart';
import 'package:terrabayt_uz/pages/widgets/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum _Status { initial, loading, fail, success }

class _HomePageState extends State<HomePage> {
  final api = di.get<NewsApi>();
  var categories = <CategoryData>[];
  var status = _Status.initial;

  Future<void> loadCategories() async {
    setState(() {
      status = _Status.loading;
    });

    try {
      categories = await api.getCategories();
      setState(() {
        status = _Status.success;
      });
    } catch (e) {
      setState(() {
        status = _Status.fail;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar()
    );
  }

  showAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: SearchWidget(),
    );
  }
}
