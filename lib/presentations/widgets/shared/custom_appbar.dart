import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/features/auth/presentation/providers/providers_auth.dart';
import 'package:recuerda_facil/presentations/screens/screens.dart';

import '../../providers/providers.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final category = ref.watch(categoryProvider);
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    final user = ref.watch(authProvider).user;
    return SliverAppBar(
      expandedHeight: size.height * 0.06,
      backgroundColor: colors.surfaceVariant.withOpacity(0.5),
      floating: true,
      flexibleSpace: FlexibleSpaceBar(
        // background: Image.network(
        //   'https://media.revistagq.com/photos/5ca5f6a77a3aec0df5496c59/master/w_1600%2Cc_limit/bob_esponja_9564.png', // reemplaza esto con la URL de tu imagen
        //   fit: BoxFit.cover,
        // ),
        collapseMode: CollapseMode.parallax,
        title: Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              Text(
                "Recuerda",
                style: TextStyle(
                    color: colors.primary,
                    fontSize: 24,
                    // fontWeight: FontWeight.bold,
                    fontFamily: 'SpicyRice-Regular'),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Fácil",
                style: TextStyle(
                    color: colors.secondary,
                    fontSize: 24,
                    // fontWeight: FontWeight.bold,
                    fontFamily: 'SpicyRice-Regular'),
              ),
            ],
          ),
        ),
        centerTitle: false,
      ),
      actions: [
        const Spacer(),
        IconButton(
            onPressed: () {
              showNewNote(context, category, user!.uid);
            },
            icon: const Icon(Icons.add)),
        IconButton(
            onPressed: () {
              // ref.read(themeNotifierProvider.notifier).toogleDarkMode();

              // ref
              //     .read(isDarkmodeProvider.notifier)
              //     .update((darkmode) => !darkmode);
              ref
                  .read(preferencesProvider.notifier)
                  .changeIsDarkMode(!isDarkMode);
              // PreferencesUser().setValue<bool>('isDarkmode', !isDarkMode);
            },
            icon: isDarkMode
                ? const Icon(Icons.light_mode_outlined)
                : const Icon(Icons.dark_mode_outlined)),
        // const Spacer(),

        TextButton(
            onPressed: () {
              context.push('/account');
            },
            child: (isDarkMode)
                ? Image.asset(
                    'assets/images/logodark.png',
                    height: 30,
                  )
                : Image.asset(
                    'assets/images/logo.png',
                    height: 30,
                  )),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }
}
