import 'package:mealdb/model/filter_area_model.dart';
import 'package:mealdb/model/filter_category_model.dart';
import 'package:mealdb/model/filter_ingredients_model.dart';
import 'package:mealdb/model/list_area_model.dart';
import 'package:mealdb/model/list_category_model.dart';
import 'package:mealdb/model/list_ingredients_model.dart';
import 'package:mealdb/model/lookup_model.dart';
import 'package:mealdb/service/base_network.dart';

class ApiDataSource {
  static final ApiDataSource _instance = ApiDataSource._internal();

  factory ApiDataSource() {
    return _instance;
  }

  ApiDataSource._internal();

  Future<ListCategoryModel> listCategory() async {
    final response = await BaseNetwork.get("list.php?c=list");
    if (response.containsKey('error')) {
      throw Exception(response['error']);
    }
    return ListCategoryModel.fromJson(response);
  }

  Future<ListAreaModel> listArea() async {
    final response = await BaseNetwork.get("list.php?a=list");
    if (response.containsKey('error')) {
      throw Exception(response['error']);
    }
    return ListAreaModel.fromJson(response);
  }

  Future<ListIngredientsModel> listIngredient() async {
    final response = await BaseNetwork.get("list.php?i=list");
    if (response.containsKey('error')) {
      throw Exception(response['error']);
    }
    return ListIngredientsModel.fromJson(response);
  }

  Future<FilterAreaModel> filterArea(String strArea) async {
    final response = await BaseNetwork.get("filter.php?a=$strArea");
    if (response.containsKey('error')) {
      throw Exception(response['error']);
    }
    return FilterAreaModel.fromJson(response);
  }

  Future<FilterCategoryModel> filterCategory(String strCategory) async {
    final response = await BaseNetwork.get("filter.php?c=$strCategory");
    if (response.containsKey('error')) {
      throw Exception(response['error']);
    }
    return FilterCategoryModel.fromJson(response);
  }

  Future<FilterIngredientsModel> filterByIngredient(String ingredient) async {
    final response = await BaseNetwork.get("filter.php?i=$ingredient");
    if (response.containsKey('error')) {
      throw Exception(response['error']);
    }
    return FilterIngredientsModel.fromJson(response);
  }

  Future<LookupModel> loadMeals() async {
    final response = await BaseNetwork.get("search.php?s=");
    if (response.containsKey('error')) {
      throw Exception(response['error']);
    }
    return LookupModel.fromJson(response);
  }

  Future<LookupModel> lookupMealsById(String idMeal) async {
    final response = await BaseNetwork.get("lookup.php?i=$idMeal");
    if (response.containsKey('error')) {
      throw Exception(response['error']);
    }
    return LookupModel.fromJson(response);
  }
}
