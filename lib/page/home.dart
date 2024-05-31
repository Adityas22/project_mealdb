import 'package:flutter/material.dart';
import 'package:mealdb/model/lookup_model.dart'; // Import LookupModel
import 'package:mealdb/page/camera.dart';
import 'package:mealdb/page/favorite.dart';
import 'package:mealdb/page/list_area.dart';
import 'package:mealdb/page/list_category.dart';
import 'package:mealdb/page/list_ingredient.dart';
import 'package:mealdb/page/logout.dart';
import 'package:mealdb/page/profile.dart';
import 'package:mealdb/service/api_data_source.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<LookupModel> _futureMeals;
  List<Meals>? _mealsList;
  List<Meals>? _filteredMealsList;
  TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _drawerItems = [
    {'title': 'Area', 'value': 'area'},
    {'title': 'Category', 'value': 'category'},
    {'title': 'Ingredient', 'value': 'ingredient'},
  ];

  @override
  void initState() {
    super.initState();
    _futureMeals = ApiDataSource().loadMeals();
    _futureMeals.then((lookupModel) {
      setState(() {
        _mealsList = lookupModel.meals ?? [];
        _filteredMealsList = _mealsList;
      });
    }).catchError((error) {
      print('Error loading meals: $error');
    });
    _searchController.addListener(_filterMealsList);
  }

  void _filterMealsList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMealsList = _mealsList?.where((meal) {
        return meal.strMeal?.toLowerCase().contains(query) ?? false;
      }).toList();
    });
  }

  void _onTabSelected(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavoritePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ImagePickDemo()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogoutPage()),
        );
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          'Meals',
          style: TextStyle(color: Colors.white),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search meals...',
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView.builder(
          itemCount: _drawerItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_drawerItems[index]['title']),
              onTap: () {
                switch (_drawerItems[index]['value']) {
                  case 'area':
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListAreaPage()),
                    );
                    break;
                  case 'category':
                    // Navigasi ke halaman kategori
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListCategory()),
                    );
                    break;
                  case 'ingredient':
                    // Navigasi ke halaman bahan
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListIngredientPage()),
                    );
                    break;
                  default:
                    break;
                }
              },
            );
          },
        ),
      ),
      body: FutureBuilder<LookupModel>(
        future: _futureMeals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.meals != null) {
            _mealsList = snapshot.data!.meals!;
            _filteredMealsList = _filteredMealsList ?? _mealsList;
            return ListView.builder(
              itemCount: _filteredMealsList?.length ?? 0,
              itemBuilder: (context, index) {
                Meals meal = _filteredMealsList![index];
                return ListTile(
                  leading: meal.strMealThumb != null
                      ? Image.network(meal.strMealThumb!)
                      : Icon(Icons.local_dining),
                  title: Text(meal.strMeal ?? ''),
                  subtitle: Text(meal.strCategory ?? ''),
                );
              },
            );
          } else {
            return Center(child: Text('No meals found.'));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: _onTabSelected,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.brown,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed, // Ensure labels are always shown
      ),
    );
  }
}
