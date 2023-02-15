import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:terrabayt_uz/api/news_api.dart';
import 'package:terrabayt_uz/data/models/category_data.dart';
import 'package:terrabayt_uz/data/models/news_data.dart';
import 'package:terrabayt_uz/data/models/status.dart';
import 'package:terrabayt_uz/di/di_module.dart';
import 'package:terrabayt_uz/resources/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Text(
            "Terrabayt.uz",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true),
      body: const CategoryBody(),
    );
  }
}

class CategoryBody extends StatefulWidget {
  const CategoryBody({Key? key}) : super(key: key);

  @override
  State<CategoryBody> createState() => _CategoryBodyState();
}

class _CategoryBodyState extends State<CategoryBody> {
  final source = di.get<NewsApi>();
  Status _status = Status.initial;
  final _categories = <CategoryData>[];
  var _selectedCategory = -1;
  final _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    _status = Status.loading;
    setState(() {});
    try {
      final data = await source.getCategories();
      _categories.clear();
      _categories.addAll(data);
      if (data.isNotEmpty) _selectedCategory = 0;
      _status = Status.success;
      setState(() {});
    } catch (e) {
      _status = Status.fail;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_status == Status.loading) {
      print("Loading");
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_status == Status.success) {
      print("Success");
      return Container(
          padding: const EdgeInsets.only(top: 10),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 40,
                width: double.infinity,
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => selectCategory(index),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: _selectedCategory == index
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  width: 1,
                                  color: _selectedCategory == index
                                      ? Colors.redAccent
                                      : Colors.grey)),
                          child: Text(
                            _categories[index].name,
                            style: TextStyle(
                                fontSize: 14,
                                color: _selectedCategory == index
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Expanded(
                child: Container(
              child: PageView.builder(
                  controller: _controller,
                  itemBuilder: (context, position) {
                    return NewsBody(_categories[_selectedCategory]);
                  }),
            ))
          ]));
    }
    if (_status == Status.fail) {
      print("Fail");
    }
    print("Initinal");
    return Container();
  }

  void selectCategory(int index) {
    setState(() {
      _selectedCategory = index;
      _controller.jumpToPage(index);
    });
  }
}

class NewsBody extends StatefulWidget {
  final CategoryData category;

  const NewsBody(this.category, {Key? key}) : super(key: key);

  @override
  State<NewsBody> createState() => _NewsBodyState();
}

class _NewsBodyState extends State<NewsBody> {
  final source = di.get<NewsApi>();
  static const _pageSize = 15;
  final PagingController<int, NewsData> _pagingController = PagingController(
      firstPageKey: (DateTime.now().millisecondsSinceEpoch ~/ 1000));

  @override
  void initState() {
    print("Init state cat id: ${widget.category.id}");
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      print("Load $pageKey page for ${widget.category.id}");
      final newItems = await source.getPost(widget.category.id, pageKey);
      final isLastPage = newItems.length < _pageSize;
      print("Load $pageKey page for ${widget.category.id}");

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = newItems.last.publishedAt;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      print(error.toString());
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Build News cat id: ${widget.category.id}");

    return PagedListView(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<NewsData>(
        itemBuilder: (context, item, index) => ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
            child: Stack(
              children: [CachedNetworkImage(imageUrl: item.image)],
            ),
          ),
        ),
      ),
    );
  }
}
