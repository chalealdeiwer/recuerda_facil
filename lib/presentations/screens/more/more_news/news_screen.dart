import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  static const name = 'news_screen';
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Noticias"),
      ),
      body: const Padding(
        padding:  EdgeInsets.all(20),
        child:  Center(
          child: Column(
            children: [
              Text(
                "Pronto tendremos noticias para ti",
                style: TextStyle(fontSize: 30),
              ),
              Text("📰",style: TextStyle(fontSize: 100),)
            ],
          )
        ),
      ),
    );
  }
}