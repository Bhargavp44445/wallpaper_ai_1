import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App',style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'About Wallpaper Ai+ App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlueAccent,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Welcome to Wallpaper Ai+, your personal collection manager for all your favorite wallpapers! '
                    'This app lets you effortlessly organize, view, and manage your wallpaper images in a simple, user-friendly interface.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Key Features:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '- Image Management: Easily add images to your collection from your gallery.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                '- Persistent Storage: Your selected wallpapers are stored securely, even when you close the app, thanks to local storage.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                '- Image Options: With a simple tap, you can save your favorite wallpapers directly to your device or remove them from your collection.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                '- Permission Control: The app ensures your privacy by asking for necessary permissions only when needed.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'User-Friendly Interface:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'A modern and intuitive grid layout showcases your wallpapers, allowing you to easily browse and select your images. '
                    'The app bar and floating action button make navigation and actions straightforward, with a focus on enhancing your user experience.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Whether you\'re customizing your device or just keeping your favorite wallpapers handy, '
                    'Wallpaper Ai+ is the perfect companion for wallpaper enthusiasts!',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
