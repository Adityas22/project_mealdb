import 'package:flutter/material.dart';
import 'package:mealdb/model/filter_category_model.dart';
import 'package:mealdb/page/lookup_category.dart';
import 'package:mealdb/service/api_data_source.dart';

class FilterCategoryPage extends StatefulWidget {
  final String category;

  FilterCategoryPage({required this.category});

  @override
  _FilterCategoryPageState createState() => _FilterCategoryPageState();
}

class _FilterCategoryPageState extends State<FilterCategoryPage> {
  late Future<FilterCategoryModel> _futureFilteredMeals;

  @override
  void initState() {
    super.initState();
    _futureFilteredMeals = ApiDataSource().filterCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meals for ${widget.category}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<FilterCategoryModel>(
        future: _futureFilteredMeals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.meals != null) {
            List<Meals> meals = snapshot.data!.meals!;
            return ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                Meals meal = meals[index];
                return ListTile(
                  title: Text(meal.strMeal ?? 'Unknown'),
                  subtitle: Text(meal.idMeal ?? 'Unknown ID'),
                  leading: meal.strMealThumb != null
                      ? Image.network(meal.strMealThumb!, fit: BoxFit.cover)
                      : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LookupCategoryPage(idMeal: meal.idMeal!),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No meals found for this category.'));
          }
        },
      ),
    );
  }
}
