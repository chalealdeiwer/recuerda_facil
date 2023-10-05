
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../services/select_image.dart';
import '../../../services/upload_image.dart';

class MoreScreen extends StatefulWidget {
  static const name = 'more_screen';
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  

  
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      appBar: AppBar(
        title: const Text("Subir Imagenes"),
      ),
      body: const Column(
        children: [Center(child: Text("more screen"),
          
        )],
        
        
      ),
    );
  }
}