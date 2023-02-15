import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:terrabayt_uz/app/app_colors.dart';

class SearchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchWidget> {
  bool isOpened = false;

  void onTapSearch() {
    setState(() {
      isOpened = !isOpened;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 10.0, right: 50.0, top: 10, bottom: 10),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(60)),
            border: Border.all(color: Colors.black45)),
        child: showSearchView(),
      ),
    );
  }

  showSearchView() {
    return GestureDetector(
      onTap: onTapSearch,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: isOpened ? showOpenedWidget() : showClosedWidgets(),
      ),
    );
  }

  showOpenedWidget() {
    return const TextField(
      decoration: InputDecoration(border: InputBorder.none),
      cursorColor: Colors.black,
      autofocus: true,
    );
  }

  showClosedWidgets() {
    return Row(children: const [
      Expanded(
        child: Text(
          "Decition to the moon",
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black45),
        ),
      ),
      SizedBox(
        height: 17,
        child: Icon(
          Icons.search,
          color: Colors.black,
        ),
      )
    ]);
  }
}
