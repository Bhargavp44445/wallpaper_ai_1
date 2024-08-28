import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as p;
import 'package:wallpaper_ai_1/aboutapp.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<File> images = [];
  GlobalKey _globalKey = GlobalKey(); // Added for saving images

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        images.add(File(pickedFile.path));
      });
      _saveImages();
    }
  }

  Future<void> _loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePaths = prefs.getStringList('imagePaths') ?? [];
    setState(() {
      images = imagePaths.map((path) => File(path)).toList();
    });
  }

  Future<void> _saveImages() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePaths = images.map((image) => image.path).toList();
    prefs.setStringList('imagePaths', imagePaths);
  }

  Future<void> _deleteImage(int index) async {
    setState(() {
      images.removeAt(index);
    });
    _saveImages();
  }

  Future<void> _requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;

    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      print('Storage permission granted');
    } else if (status.isPermanentlyDenied) {
      print('Storage permission permanently denied');
      openAppSettings();
    } else {
      print('Storage permission not granted: $status');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission not granted')),
      );
    }
  }

  Future<void> _saveLocalImage(File image) async {
    await _requestStoragePermission(); // Ensure permission is requested

    if (await Permission.storage.isGranted) {
      try {
        final bytes = await image.readAsBytes();
        final result = await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));

        if (result['isSuccess']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image saved to gallery')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save image')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save image: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission is needed to save images.')),
      );
    }
  }

  void _showImageOptions(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Option',style: TextStyle(fontWeight: FontWeight.bold),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.delete,color: Colors.red,),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.of(context).pop();
                  _deleteImage(index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.save,color: Colors.green,),
                title: const Text('Save to device'),
                onTap: () {
                  Navigator.of(context).pop();
                  _saveLocalImage(images[index]);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallpaper Collection',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.lightBlueAccent,
        iconTheme: IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
      ),
      drawer: Menu(),
      body: SafeArea(
        child: images.isEmpty
            ? Center(
          child: Text(
            'Add Images',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            :GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _showImageOptions(context, index),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: _pickImage,
        child: const Icon(Icons.add,color: Colors.white,),
        shape: const CircleBorder(),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  const Menu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Padding(
              padding: EdgeInsets.only(top: 110),
              child: Text('', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
    decoration: BoxDecoration(color: Colors.lightBlueAccent,
    image: DecorationImage(
    image: AssetImage("assets/WALLPAPER.png"),
      fit: BoxFit.cover,
    ),
    ),),
          ListTile(
            leading: Icon(Icons.description),
            title: const Text('Privacy Policy'),
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: const Text('Share This App'),
          ),
          ListTile(
            leading: Icon(Icons.reviews),
            title: const Text('Rate This App'),
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.error),
            title: const Text('About App'),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutApp(),),);
            }
          ),
        ],
      ),
    );
  }
}
