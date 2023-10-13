import 'package:flutter/material.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Center(
        child: Column(children: [
          const SizedBox(
            height: 50,
          ),
          Text(
            "Más Recursos",
            style:
                textStyle.displaySmall!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colors.surfaceVariant,
            ),
            margin: const EdgeInsets.all(20),
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
                          const Icon(
                            Icons.newspaper,
                            size: 100,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Noticias",
                            style: textStyle.titleLarge,
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
                          const Icon(
                            Icons.gamepad_outlined,
                            size: 100,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Mini juegos",
                            style: textStyle.titleLarge,
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
                          const Icon(Icons.table_view, size: 100),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Tableros",
                            style: textStyle.titleLarge,
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
                        const Icon(Icons.timer, size: 100),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Productividad",
                            style: textStyle.titleLarge,
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
