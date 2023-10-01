import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  static const name = 'about_screen';
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: TextButton(onPressed: (){
          showAboutDialog( 
            
            context: context);
        }, child: Text("Licencias de uso")),
      ),
    );
  }
}