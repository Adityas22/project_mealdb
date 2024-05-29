import 'package:flutter/material.dart';
import 'package:mealdb/model/filter_area_model.dart';
import 'package:mealdb/page/lookup_area.dart';
import 'package:mealdb/service/api_data_source.dart';

class FilterAreaPage extends StatelessWidget {
  final String area;

  FilterAreaPage({required this.area});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals in $area'),
        backgroundColor: Colors.brown,
      ),
      body: FutureBuilder<FilterAreaModel>(
        future: ApiDataSource().filterArea(area),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!.meals == null ||
              snapshot.data!.meals!.isEmpty) {
            return Center(child: Text('No meals found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.meals!.length,
              itemBuilder: (context, index) {
                Meals meal = snapshot.data!.meals![index];
                return ListTile(
                  title: Text(meal.strMeal ?? ''),
                  subtitle: Text(meal.idMeal ?? ''),
                  leading: meal.strMealThumb != null
                      ? Image.network(meal.strMealThumb!)
                      : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LookupAreaPage(idMeal: meal.idMeal!),
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
