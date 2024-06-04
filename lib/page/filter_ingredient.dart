import 'package:flutter/material.dart';
import 'package:mealdb/model/filter_ingredients_model.dart';
import 'package:mealdb/page/lookup_ingredient.dart';
import 'package:mealdb/service/api_data_source.dart';

class FilteredIngredientsPage extends StatelessWidget {
  final String ingredient;

  FilteredIngredientsPage({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meals with $ingredient',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<FilterIngredientsModel>(
        future: ApiDataSource().filterByIngredient(ingredient),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!.meals == null ||
              snapshot.data!.meals!.isEmpty) {
            return Center(child: Text('No meals found'));
          } else {
            final meals = snapshot.data!.meals!;
            return ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return ListTile(
                  title: Text(meal.strMeal ?? 'No title'),
                  subtitle: Text(meal.idMeal ?? 'No ID'),
                  leading: meal.strMealThumb != null
                      ? Image.network(meal.strMealThumb!)
                      : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LookupIngredientPage(idMeal: meal.idMeal!),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
