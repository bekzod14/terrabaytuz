// To parse this JSON data, do
//
//     final categoryData = categoryDataFromMap(jsonString);

import 'dart:convert';

List<CategoryData> categoryDataFromMap(String str) => List<CategoryData>.from(
    json.decode(str).map((x) => CategoryData.fromMap(x)));

String categoryDataToMap(List<CategoryData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class CategoryData {
  CategoryData({
    required this.id,
    required this.name,
    required this.slug,
    this.child,
  });

  int id;
  String name;
  String slug;
  List<CategoryData>? child;

  factory CategoryData.fromMap(Map<String, dynamic> json) => CategoryData(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        child: json["child"] == null
            ? []
            : List<CategoryData>.from(
                json["child"]!.map((x) => CategoryData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "slug": slug,
        "child": child == null
            ? []
            : List<dynamic>.from(child!.map((x) => x.toMap())),
      };
}
