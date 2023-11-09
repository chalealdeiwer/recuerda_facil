import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/services/comments_service.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key});
  static const name = 'comments_screen';
  bool validateFields(String name, String comment) {
    return name.isNotEmpty && comment.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerComment = TextEditingController();
    int ratingA;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comentarios"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Icon(
                Icons.comment,
                size: 100,
              ),
              const Text(
                "Déjanos tu comentario",
                style: TextStyle(fontSize: 30),
              ),
              Container(
                height: 400,
                width: 300,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: Column(
                  children: [
                    const Text(
                      "Ingresa tu nombre",
                      style: TextStyle(fontSize: 20),
                    ),
                    TextField(
                      controller: controllerName,
                      decoration: const InputDecoration(
                        hintText: "Nombre",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Ingresa tus comentarios",
                      style: TextStyle(fontSize: 20),
                    ),
                    TextField(
                      maxLines: 5,
                      controller: controllerComment,
                      decoration: const InputDecoration(
                        hintText: "Comentarios",
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: 4,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 40.0,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        ratingA=rating.toInt();
                      },
                    )
                  ],
                ),
              ),
              FilledButton(
                onPressed: () {
                  final name = controllerName.text;
                  final comment = controllerComment.text;

                  if (validateFields(name, comment)) {
                    saveComment(name, comment, 6, DateTime.now());
                    controllerComment.clear();
                    controllerName.clear();
                    
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title:  const Text("Información"),
                        content:   const Text("Gracias por tu comentario"),
                        actions: [
                          TextButton(onPressed: (){
                            context.pop();
                          }, child: const Text("Aceptar")),
                        ],
                      );
                      
                    },);
                  } else {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title:  const Text("Información"),
                        content:   const Text("Por favor, ingrese todos los campos"),
                        actions: [
                          TextButton(onPressed: (){
                            context.pop();
                          }, child: const Text("Aceptar")),
                        ],
                      );
                    },);
                  }
                },
                child: const Text("Enviar", style: TextStyle(fontSize: 30)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
