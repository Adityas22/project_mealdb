class MealModel {
  final String idMeal;
  final String strMeal;
  final String? strCategory;
  final String? strArea;
  final String? strInstructions;
  final String? strMealThumb;
  final List<String>? strIngredients;

  MealModel({
    required this.idMeal,
    required this.strMeal,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strMealThumb,
    this.strIngredients,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strCategory: json['strCategory'],
      strArea: json['strArea'],
      strInstructions: json['strInstructions'],
      strMealThumb: json['strMealThumb'],
      strIngredients: _parseIngredients(json),
    );
  }

  static List<String>? _parseIngredients(Map<String, dynamic> json) {
    final List<String>? ingredients = [];
    for (int i = 1; i <= 20; i++) {
      if (json['strIngredient$i'] != null) {
        ingredients!.add(json['strIngredient$i']);
      } else {
        break;
      }
    }
    return ingredients;
  }
}
