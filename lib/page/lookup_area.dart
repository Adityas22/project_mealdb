import 'package:flutter/material.dart';
import 'package:mealdb/model/lookup_model.dart';
import 'package:mealdb/page/home.dart';
import 'package:mealdb/service/api_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LookupAreaPage extends StatefulWidget {
  final String idMeal;

  LookupAreaPage({required this.idMeal});

  @override
  _LookupAreaPageState createState() => _LookupAreaPageState();
}

class _LookupAreaPageState extends State<LookupAreaPage> {
  bool isFavorite = false;
  late String username;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? '';
    setState(() {
      isFavorite = prefs.getBool('$username-${widget.idMeal}') ?? false;
    });
  }

  _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
      prefs.setBool('$username-${widget.idMeal}', isFavorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null),
            onPressed: _toggleFavorite,
          ),
        ],
        backgroundColor: Colors.brown,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<LookupModel>(
        future: ApiDataSource().lookupMealsById(widget.idMeal),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!.meals == null ||
              snapshot.data!.meals!.isEmpty) {
            return Center(child: Text('No details found.'));
          } else {
            Meals meal = snapshot.data!.meals![0];
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (meal.strMealThumb != null)
                      Center(
                        child: Image.network(meal.strMealThumb!,
                            fit: BoxFit.cover),
                      ),
                    SizedBox(height: 16.0),
                    Text(meal.strMeal ?? 'No name',
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16.0),
                    Text('Category: ${meal.strCategory ?? 'N/A'}',
                        style: TextStyle(fontSize: 18.0)),
                    Text('Area: ${meal.strArea ?? 'N/A'}',
                        style: TextStyle(fontSize: 18.0)),
                    SizedBox(height: 16.0),
                    Text('Instructions:',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                    Text(meal.strInstructions ?? 'No instructions',
                        style: TextStyle(fontSize: 16.0)),
                    SizedBox(height: 16.0),
                    if (meal.strYoutube != null)
                      Text('YouTube: ${meal.strYoutube}',
                          style: TextStyle(fontSize: 16.0, color: Colors.blue)),
                    SizedBox(height: 16.0),
                    Text('Ingredients:',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                    ...List.generate(20, (index) {
                      final ingredient =
                          meal.toJson()['strIngredient${index + 1}'];
                      final measure = meal.toJson()['strMeasure${index + 1}'];
                      if (ingredient != null && ingredient.isNotEmpty) {
                        return Text('$ingredient: $measure');
                      }
                      return SizedBox.shrink();
                    }),
                    SizedBox(height: 50.0),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                        child: Text('Back to Home',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.purple)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
