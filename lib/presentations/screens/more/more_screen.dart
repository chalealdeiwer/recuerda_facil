import 'dart:io';
import 'dart:math';

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
    final colors = Theme.of(context).colorScheme;
    final textSyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Más"),
      ),
      body: Center(
        child: Column(children: [
          Text(
            "Más Recursos",
            style: textSyle.displaySmall,
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colors.surfaceVariant,
              
            
            ),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colors.primary.withOpacity(0.2),
                      ),
                      width: 150,
                      height: 150,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            "assets/circleLogo.png",
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Noticias",
                            style: textSyle.titleLarge,
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colors.primary.withOpacity(0.2),
                      ),
                      width: 150,
                      height: 150,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            "assets/circleLogo.png",
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Mini juegos",
                            style: textSyle.titleLarge,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colors.primary.withOpacity(0.2),
                      ),
                      width: 150,
                      height: 150,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            "assets/circleLogo.png",
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Tableros",
                            style: textSyle.titleLarge,
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colors.primary.withOpacity(0.2),
                      ),
                      width: 150,
                      height: 150,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            "assets/circleLogo.png",
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Productividad",
                            style: textSyle.titleLarge,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
