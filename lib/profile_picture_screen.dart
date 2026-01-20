import 'dart:io';

import 'package:flutter/material.dart';

class ProfilePictureScreen extends StatelessWidget {
  final String imageUrl;

  const ProfilePictureScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isFile = File(imageUrl).existsSync();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4,
          child: isFile
              ? Image.file(File(imageUrl))
              : Image.network(imageUrl),
        ),
      ),
    );
  }
}
