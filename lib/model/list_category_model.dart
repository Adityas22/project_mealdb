class ListCategoryModel {
  final List<Meals>? meals;

  ListCategoryModel({
    this.meals,
  });

  ListCategoryModel.fromJson(Map<String, dynamic> json)
      : meals = (json['meals'] as List?)
            ?.map((dynamic e) => Meals.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'meals': meals?.map((e) => e.toJson()).toList()};
}

class Meals {
  final String? strCategory;

  Meals({
    this.strCategory,
  });

  Meals.fromJson(Map<String, dynamic> json)
      : strCategory = json['strCategory'] as String?;

  Map<String, dynamic> toJson() => {'strCategory': strCategory};
}
