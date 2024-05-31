import 'package:flutter/material.dart';
import 'package:mealdb/model/lookup_model.dart';
import 'package:mealdb/page/lookup_area.dart';
import 'package:mealdb/service/api_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Meals> favoriteMeals = [];
  late String username;

  @override
  void initState() {
    super.initState();
    _loadFavoriteMeals();
  }

  _loadFavoriteMeals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? '';
    Set<String> keys = prefs.getKeys();
    List<String> userFavoriteMeals = keys
        .where(
            (key) => key.startsWith('$username-') && prefs.getBool(key) == true)
        .map((key) => key.split('-')[1])
        .toList();

    List<Future<LookupModel>> futureMeals = userFavoriteMeals.map((id) {
      return ApiDataSource().lookupMealsById(id);
    }).toList();

    Future.wait(futureMeals).then((List<LookupModel> mealsList) {
      List<Meals> meals = mealsList.map((lookupModel) {
        return lookupModel.meals![0];
      }).toList();

      setState(() {
        favoriteMeals = meals;
      });
    });
  }

  _removeFavorite(String mealId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$username-$mealId', false);
    _loadFavoriteMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Meals'),
        backgroundColor: Colors.brown,
      ),
      body: favoriteMeals.isEmpty
          ? Center(child: Text('No favorite meals'))
          : ListView.builder(
              itemCount: favoriteMeals.length,
              itemBuilder: (context, index) {
                Meals meal = favoriteMeals[index];
                return ListTile(
                  leading: meal.strMealThumb != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(meal.strMealThumb!),
                        )
                      : CircleAvatar(),
                  title: Text(meal.strMeal ?? 'Unknown'),
                  subtitle: Text(meal.strSource ?? 'Unknown'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _removeFavorite(meal.idMeal ?? '');
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LookupAreaPage(idMeal: meal.idMeal ?? ''),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
