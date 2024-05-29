import 'package:flutter/material.dart';
import 'package:mealdb/model/lookup_model.dart';
import 'package:mealdb/service/api_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<String> favoriteMeals = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteMeals = prefs.getKeys().toList();
    });
  }

  _removeFromFavorites(String idMeal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove(idMeal);
      favoriteMeals.remove(idMeal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Meals'),
        backgroundColor: Colors.brown,
      ),
      body: ListView.builder(
        itemCount: favoriteMeals.length,
        itemBuilder: (context, index) {
          String idMeal = favoriteMeals[index];
          return FutureBuilder<LookupModel>(
            future: ApiDataSource().lookupMealsById(idMeal),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData &&
                  snapshot.data!.meals != null &&
                  snapshot.data!.meals!.isNotEmpty) {
                Meals meal = snapshot.data!.meals![0];
                return ListTile(
                  title: Text(meal.strMeal ?? 'No name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tag: ${meal.strTags ?? 'Not found'}'),
                      Text('Youtube: ${meal.strYoutube ?? 'Not found'}'),
                    ],
                  ),
                  leading: meal.strMealThumb != null
                      ? Image.network(meal.strMealThumb!)
                      : null,
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _removeFromFavorites(idMeal);
                    },
                  ),
                );
              } else {
                return SizedBox
                    .shrink(); // Return an empty container if no data is available
              }
            },
          );
        },
      ),
    );
  }
}
