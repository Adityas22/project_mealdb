import 'package:flutter/material.dart';
import 'package:mealdb/model/list_ingredients_model.dart';
import 'package:mealdb/page/filter_ingredient.dart';
import 'package:mealdb/service/api_data_source.dart';

class ListIngredientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingredients'),
      ),
      body: FutureBuilder<ListIngredientsModel>(
        future: ApiDataSource().listIngredient(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!.meals == null ||
              snapshot.data!.meals!.isEmpty) {
            return Center(child: Text('No ingredients found'));
          } else {
            final ingredients = snapshot.data!.meals!;
            return ListView.builder(
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = ingredients[index];
                return ListTile(
                  title: Text(ingredient.strIngredient ?? 'No name'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilteredIngredientsPage(
                          ingredient: ingredient.strIngredient ?? '',
                        ),
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
