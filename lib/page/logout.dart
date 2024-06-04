import 'package:flutter/material.dart';
import 'package:mealdb/page/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

String loginBox = 'loginBox';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Card(
          elevation: 8.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Apakah Anda yakin ingin keluar?',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  ElevatedButton(
                    child: Text('Tidak'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Ya'),
                    onPressed: () {
                      _logout(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    print('Logout started');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    print('Navigating to LoginPage');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
      (route) => false,
    );
  }
}
