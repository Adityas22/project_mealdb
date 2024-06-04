import 'package:flutter/material.dart';
import 'package:mealdb/model/list_area_model.dart';
import 'package:mealdb/page/filter_area.dart';
import 'package:mealdb/service/api_data_source.dart';

class ListAreaPage extends StatefulWidget {
  @override
  _ListAreaPageState createState() => _ListAreaPageState();
}

class _ListAreaPageState extends State<ListAreaPage> {
  late Future<ListAreaModel> _futureListArea;

  @override
  void initState() {
    super.initState();
    _futureListArea = ApiDataSource().listArea();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Area',
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
      body: FutureBuilder<ListAreaModel>(
        future: _futureListArea,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!.meals == null ||
              snapshot.data!.meals!.isEmpty) {
            return Center(child: Text('No areas found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.meals!.length,
              itemBuilder: (context, index) {
                Meals meal = snapshot.data!.meals![index];
                return ListTile(
                  title: Text(meal.strArea ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FilterAreaPage(area: meal.strArea ?? ''),
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
