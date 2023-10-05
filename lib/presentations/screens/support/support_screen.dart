import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/presentations/screens/splash_screen/splash_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});
  static const name = 'support_screen';
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.support_agent_rounded,
                size: 100,
              ),
              Text(
                "Soporte / Ayuda",
                style: textStyle.displaySmall,
              ),
              Text(
                "Una nueva experiencia de servicio",
                style: textStyle.titleLarge,
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: (){
                  context.push('/support/contact_info');
                },
                child: Column(
                  children: [
                    const Icon(
                      Icons.account_circle_rounded,
                      size: 100,
                    ),
                    Text(
                      "Información de contacto",
                      style: textStyle.displaySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40,),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push('/support/faq');
                    },
                    child: Column(
                      children: [
                        const Icon(
                          Icons.question_mark_rounded,
                          size: 100,
                        ),
                        Text(
                          "Preguntas\nFrecuentes\n(FAQ)",
                          style: textStyle.displaySmall,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/support/comments');
                    },
                    child: Column(
                      children: [
                        const Icon(
                          Icons.comment_rounded,
                          size: 100,
                        ),
                        Text(
                          "\nComentarios",
                          style: textStyle.displaySmall,
                        )
                      ],
                    ),
                  )
                ],
              )

                  ],
                ),
              )
              
            ],
          ),
        ),
      ),
    );
  }
}
