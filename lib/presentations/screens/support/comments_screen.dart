import 'package:flutter/material.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key});
  static const name = 'comments_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comentarios"),
      
      ),
      body: Center(
        child: Column(
          
          children: [
            const SizedBox(height: 30,),
            const Icon(Icons.comment,size: 100,),
            const Text("Déjanos tu comentario",style: TextStyle(fontSize: 30),),
            Container(
              height: 400,
              width: 300,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              child: const Column(
                children: [
                  Text("...", style: TextStyle(fontSize: 20),),
                ],
              ),

            ),
            FilledButton(onPressed: (){}, child: const Text("Enviar", style: TextStyle(fontSize: 30)),),
          ],
        ),
      ),
    );
  }
}