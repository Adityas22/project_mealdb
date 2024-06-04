import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
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
      body: ListView(
        children: [
          ProfileMember(
            name: 'Aditya Septiawan',
            nim: '123210014',
            photoUrl: 'assets/Aditya.jpg',
          ),
          ProfileMember(
            name: 'Muhammad Ihsanuddin',
            nim: '123210039',
            photoUrl: 'assets/ihsan.jpeg',
          ),
          ProfileMember(
            name: 'Husnan Maulana Suprayitno',
            nim: '123210105',
            photoUrl: 'assets/husnan.jpeg',
          ),
        ],
      ),
    );
  }
}

class ProfileMember extends StatelessWidget {
  final String name;
  final String nim;
  final String photoUrl;

  ProfileMember({
    required this.name,
    required this.nim,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50.0,
            backgroundImage: AssetImage(photoUrl), // Change to AssetImage
          ),
          SizedBox(height: 10.0),
          Text(
            name,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          Text(
            'NIM: $nim',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
