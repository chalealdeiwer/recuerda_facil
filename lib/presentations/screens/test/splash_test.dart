import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/services/url_launcher_service.dart';

import '../../providers/providers.dart';

class SplashTest extends ConsumerWidget {
  const SplashTest({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    return Scaffold(
      backgroundColor: const Color(0xFFE8EDDB),
      body: Center(
        child: GestureDetector(
          onTap: () {
            launchUrlService("https://www.google.com/");

          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 200,
                              width: 200,
                              child: Image.asset(
                                isDarkMode
                                    // ? "assets/circleLogoWhite.png"
                                    // : "assets/circleLogo.png",
                                    ? "assets/images/logodark.png"
                                    : "assets/images/logo.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            "Recuerda",
                            style: TextStyle(
                                fontFamily: 'SpicyRice-Regular',
                                fontSize: 80,
                                color: colors.primary),
                          ),
                          Text(
                            "Fácil",
                            style: TextStyle(
                                fontFamily: 'SpicyRice-Regular',
                                fontSize: 75,
                                color: colors.secondary),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
