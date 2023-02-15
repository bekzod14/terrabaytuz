// To parse this JSON data, do
//
//     final newsData = newsDataFromMap(jsonString);

import 'dart:convert';

List<NewsData> newsDataFromMap(String str) =>
    List<NewsData>.from(json.decode(str).map((x) => NewsData.fromMap(x)));

String newsDataToMap(List<NewsData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class NewsData {
  NewsData({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.publishedAt,
    required this.updatedAt,
    required this.postId,
    required this.postModified,
    this.categoryId,
    required this.categoryName,
    required this.image,
    required this.url,
    required this.priority,
    required this.order,
  });

  int id;
  String title;
  String excerpt;
  String content;
  int publishedAt;
  int updatedAt;
  String postId;
  String postModified;
  int? categoryId;
  CategoryName categoryName;
  String image;
  String url;
  String priority;
  String order;

  factory NewsData.fromMap(Map<String, dynamic> json) => NewsData(
        id: json["id"],
        title: json["title"],
        excerpt: json["excerpt"],
        content: json["content"],
        publishedAt: json["published_at"],
        updatedAt: json["updated_at"],
        postId: json["post_id"],
        postModified: json["post_modified"],
        categoryId: json["category_id"],
        categoryName: categoryNameValues.map[json["category_name"]]!,
        image: json["image"],
        url: json["url"],
        priority: json["priority"],
        order: json["order"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "excerpt": excerpt,
        "content": content,
        "published_at": publishedAt,
        "updated_at": updatedAt,
        "post_id": postId,
        "post_modified": postModified,
        "category_id": categoryId,
        "category_name": categoryNameValues.reverse[categoryName],
        "image": image,
        "url": url,
        "priority": priority,
        "order": order,
      };
}

enum CategoryName { XABARLAR, NARXLAR, TAVSIF, TELEVIZOR }

final categoryNameValues = EnumValues({
  "Narxlar": CategoryName.NARXLAR,
  "Tavsif": CategoryName.TAVSIF,
  "Televizor": CategoryName.TELEVIZOR,
  "Xabarlar": CategoryName.XABARLAR
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
