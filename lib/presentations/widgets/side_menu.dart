import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/config/menu/menu_items.dart';
import 'package:animate_do/animate_do.dart';
import '../../features/auth/presentation/providers/providers_auth.dart';
import '../providers/providers.dart';

class SideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({super.key, required this.scaffoldKey});

  @override
  ConsumerState<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends ConsumerState<SideMenu> {
  int navDrawerIndex = 0;
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    if (FirebaseAuth.instance.currentUser == null) {
      return const CircularProgressIndicator();
    }
    final userUid = ref.watch(authProvider).user!.uid;
    final userAcc = ref.watch(userProviderr(userUid!));
    // final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final colors = Theme.of(context).colorScheme;
    return NavigationDrawer(
      backgroundColor: colors.background,
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) {
        setState(() {
          navDrawerIndex = value;
        });

        final menuItem = appMenuItems[value];
        context.push(menuItem.link);
        print(menuItem.link);
        if (menuItem.link == "/home/1") {
          ref
              .read(buttonPageChangeProvider.notifier)
              .update((showButton) => true);
        } else {
          if (menuItem.link == "/home/2") {
            ref
                .read(buttonPageChangeProvider.notifier)
                .update((showButton) => false);
          } else {
            if (menuItem.link == "/home/0") {
              ref
                  .read(buttonPageChangeProvider.notifier)
                  .update((showButton) => false);
            } else {
              ref
                  .read(buttonPageChangeProvider.notifier)
                  .update((showButton) => true);
            }
          }
        }

        widget.scaffoldKey.currentState?.closeDrawer();
      },
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: GestureDetector(
                onTap: () {
                  context.push('/account');
                },
                child: FadeInRight(
                  delay: const Duration(milliseconds: 200),
                  child: ClipRRect(
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(0, 0, 0, 0),

                      radius: 50,
                      backgroundImage: NetworkImage(userAcc.when(
                        data: (data) {
                          return data!.photoURL.toString();
                        },
                        error: (error, stackTrace) {
                          return "error";
                        },
                        loading: () {
                          return "loading";
                        },
                      )), // Ruta de la imagen
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              userAcc.when(
                data: (data) {
                  return data!.displayName.toString();
                },
                error: (error, stackTrace) {
                  return "error";
                },
                loading: () {
                  return "loading";
                },
              ),
              style: const TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "Principal",
                  style: textStyle.bodyLarge,
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
        ),
        ...appMenuItems.sublist(0, 3).map((e) => NavigationDrawerDestination(
            icon: Icon(e.icon),
            label: Text(
              e.title,
              style: textStyle.titleLarge,
            ))),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "Más Opciones",
                  style: textStyle.bodyLarge,
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
        ),
        ...appMenuItems.sublist(3).map((e) => NavigationDrawerDestination(
            icon: Icon(e.icon),
            label: Text(
              e.title,
              style: textStyle.titleLarge,
            ))),
        Padding(
          padding: const EdgeInsets.only(left: 17.0),
          child: TextButton(
              onPressed: () async {
                ref.read(authProvider.notifier).logout();
                ref.read(preferencesProvider.notifier).appearanceDefault();
                ref.watch(categoryProvider.notifier).update((state) => "Todos");
                ref.watch(indexCategoryProvider.notifier).update((state) => 0);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.close,
                    color: colors.error,
                  ),
                  Text("   Cerrar sesión",
                      style:
                          textStyle.titleLarge!.copyWith(color: colors.error)),
                ],
              )),
        ),
        IconButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            icon: const Icon(
              Icons.exit_to_app,
            )),
        const SizedBox(
          height: 40,
        )
      ],
    );
  }
}
