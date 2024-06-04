import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mealdb/page/helper.dart';

class ImagePickDemo extends StatefulWidget {
  @override
  _ImagePickDemoState createState() => _ImagePickDemoState();
}

class _ImagePickDemoState extends State<ImagePickDemo> {
  String _imagePath = "";
  String _username = "";
  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "";
    });
    _loadImagePath();
  }

  Future<void> _loadImagePath() async {
    if (_username.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _imagePath = prefs.getString('imagePath_$_username') ?? "";
      });
    }
  }

  Future<void> _saveImagePath(String path) async {
    if (_username.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('imagePath_$_username', path);
    }
  }

  Future<String?> getImage(bool fromCamera) async {
    String? imagePath;
    if (fromCamera) {
      await _imagePickerHelper.getImageFromCamera((path) {
        imagePath = path;
      });
    } else {
      await _imagePickerHelper.getImageFromGallery((path) {
        imagePath = path;
      });
    }
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Image Pick Demo",
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                String? imagePath = await getImage(false);
                if (imagePath != null) {
                  setState(() {
                    _imagePath = imagePath;
                  });
                  _saveImagePath(imagePath);
                }
              },
              icon: Icon(Icons.insert_drive_file),
            ),
            SizedBox(
              height: 10,
            ),
            IconButton(
              onPressed: () async {
                String? imagePath = await getImage(true);
                if (imagePath != null) {
                  setState(() {
                    _imagePath = imagePath;
                  });
                  _saveImagePath(imagePath);
                }
              },
              icon: Icon(Icons.camera_alt),
            ),
            _imagePath.isEmpty
                ? Container()
                : Image.file(
                    File(_imagePath),
                    height: 300,
                    width: 300,
                  ),
          ],
        ),
      ),
    );
  }
}
