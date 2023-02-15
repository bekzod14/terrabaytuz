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
import 'package:terrabayt_uz/utils/int_extensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final source = di.get<NewsApi>();

  final _categories = <CategoryData>[];
  var _selectedCategory = -1;
  Status _status = Status.initial;
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
      data.removeWhere((element) => element.id == 2);
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
      body: Column(
        children: [
          CategoryBody(_categories, _selectedCategory,
              (index) => {selectCategory(index)}),
          Expanded(
              child: _selectedCategory != -1
                  ? PageView.builder(
                      // physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) => {selectCategory(index)},
                      controller: _controller,
                      itemBuilder: (context, position) {
                        return NewsBody(_categories[_selectedCategory]);
                      })
                  : Container())
        ],
      ),
    );
  }

  selectCategory(int index) {
    setState(() {
      _selectedCategory = index;
      _controller.jumpToPage(index);
    });
  }
}

class Temp extends StatelessWidget {
  const Temp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CategoryBody extends StatelessWidget {
  final List<CategoryData> _categories;
  final _selectedCategory;

  Function(int) onCategorySelected;

  CategoryBody(
      this._categories, this._selectedCategory, this.onCategorySelected,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          height: 40,
          width: double.infinity,
          child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 11),
              itemCount: _categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onCategorySelected(index),
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
    );
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
    return PagedListView(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<NewsData>(
        itemBuilder: (context, item, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Container(
              height: 200,
              width: double.infinity,
              child: Stack(
                children: [
                  // Container(color: Colors.white,),
                  CachedNetworkImage(
                      imageUrl: item.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          stops: <double>[0, 0.4, 0.6, 1],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.black,
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black
                          ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 16),
                    child: Column(
                      children: [
                        Text(item.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                        Expanded(child: Container()),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(item.updatedAt.toWeekDateMonthYear(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
