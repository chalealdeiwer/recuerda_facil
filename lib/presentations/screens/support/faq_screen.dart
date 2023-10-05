import 'package:flutter/material.dart';
import 'package:recuerda_facil/presentations/screens/support/questions_items.dart';
import 'package:velocity_x/velocity_x.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});
  static const name = 'faq_screen';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
  appBar: AppBar(),
  body: Center(
    child: Column(
      children: [
        const Icon(
          Icons.question_mark_rounded,
          size: 100,
        ),
        Text(
          "Preguntas frecuentes (FAQ)",
          style: textStyle.displaySmall,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              return ExpansionTile(
                leading: Icon(question.icon),
                title: Text(question.title,style: textStyle.titleLarge,),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(question.answer,style: textStyle.bodyLarge,),
                  ),
                ],
                // Opcional: cambiar el icono de expansión
                // trailing: Icon(Icons.arrow_drop_down),
              );
            },
          ),
        ),
      ],
    ),
  ),
);
  }
}
