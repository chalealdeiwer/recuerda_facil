import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/presentations/widgets/widgets.dart';

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
          customTitle(context, title1: "Más ", size1: 35,title2: "Recursos", size2: 30),
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
                    // GestureDetector(
                    //   onTap: () {
                    //     context.push('/more/news');
                    //   },
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       color: colors.primary.withOpacity(0.2),
                    //     ),
                    //     width: 150,
                    //     height: 150,
                    //     child: Column(
                    //       children: [
                    //         const SizedBox(
                    //           height: 10,
                    //         ),
                    //         FadeInLeft(
                    //           child: const Icon(
                    //             Icons.newspaper,
                    //             size: 100,
                    //           ),
                    //         ),
                    //         const SizedBox(
                    //           height: 10,
                    //         ),
                    //         Text(
                    //           "Noticias",
                    //           style: textStyle.titleLarge,
                    //           textScaleFactor: 1,
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () {
                        context.push('/more_functions');
                      },
                      child: Container(
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
                            FadeInRight(
                              child: const Icon(
                                Icons.data_saver_on_outlined,
                                size: 100,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Cuidador",
                              style: textStyle.titleLarge,
                              textScaleFactor: 1,

                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push('/more/games');
                      },
                      child: Container(
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
                            FadeInRight(
                              child: const Icon(
                                Icons.gamepad_outlined,
                                size: 100,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Mini juegos",
                              style: textStyle.titleLarge,
                              textScaleFactor: 1,

                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     GestureDetector(
                //       onTap:() {
                //         context.push('/more/boards');
                //       },
                //       child: Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10),
                //           color: colors.primary.withOpacity(0.2),
                //         ),
                //         width: 150,
                //         height: 150,
                //         child: Column(
                //           children: [
                //             const SizedBox(
                //               height: 10,
                //             ),
                //             FadeInLeft(child: const Icon(Icons.table_view, size: 100)),
                //             const SizedBox(
                //               height: 10,
                //             ),
                //             Text(
                //               "Tableros",
                //               style: textStyle.titleLarge,
                //               textScaleFactor: 1,
                              

                //             )
                //           ],
                //         ),
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap:(){
                //         context.push('/more/productivity');
                //       },
                //       child: Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10),
                //           color: colors.primary.withOpacity(0.2),
                //         ),
                //         width: 150,
                //         height: 150,
                //         child: Column(
                //           children: [
                //             const SizedBox(
                //               height: 10,
                //             ),
                //             FadeInRight(child: const Icon(Icons.timer, size: 100)),
                //             const SizedBox(
                //               height: 10,
                //             ),
                //             Text(
                //               "Productividad",
                //               style: textStyle.titleLarge,
                //               textScaleFactor: 1,

                //             )
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
