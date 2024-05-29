import 'package:flutter/material.dart';
import 'package:mealdb/model/list_category_model.dart';
import 'package:mealdb/service/api_data_source.dart';
import 'filter_category.dart';

class ListCategory extends StatefulWidget {
  @override
  _ListCategoryState createState() => _ListCategoryState();
}

class _ListCategoryState extends State<ListCategory> {
  late Future<ListCategoryModel> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = ApiDataSource().listCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        backgroundColor: Colors.brown,
      ),
      body: FutureBuilder<ListCategoryModel>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.meals != null) {
            List<Meals> categories = snapshot.data!.meals!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                Meals category = categories[index];
                return ListTile(
                  title: Text(category.strCategory ?? 'Unknown'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilterCategoryPage(
                            category: category.strCategory ?? ''),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No categories found.'));
          }
        },
      ),
    );
  }
}
