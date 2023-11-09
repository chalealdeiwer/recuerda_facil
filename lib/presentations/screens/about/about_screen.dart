import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  static const name = 'about_screen';
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(onPressed: (){
          showAboutDialog( 
            
            context: context);
        }, child: const Text("Licencias de uso")),
      ),
    );
  }
}