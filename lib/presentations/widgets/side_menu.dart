import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recuerda_facil/config/menu/menu_items.dart';
import 'package:animate_do/animate_do.dart';

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
    final userAcc =
        ref.watch(userProviderr(FirebaseAuth.instance.currentUser!.uid));
    // final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final colors = Theme.of(context).colorScheme;
    return NavigationDrawer(
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) {
        setState(() {
          navDrawerIndex = value;
        });

        final menuItem = appMenuItems[value];
        context.push(menuItem.link);
        widget.scaffoldKey.currentState?.closeDrawer();
      },
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
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
                        return "errror";
                      },
                      loading: () {
                        return "loading";
                      },
                    )), // Ruta de la imagen
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              FirebaseAuth.instance.currentUser!.displayName.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text("Principal"),
              ),
              Expanded(child: Divider()),
            ],
          ),
        ),
        ...appMenuItems.sublist(0, 3).map((e) => NavigationDrawerDestination(
            icon: Icon(e.icon), label: Text(e.title))),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text("Más Opciones"),
              ),
              Expanded(child: Divider()),
            ],
          ),
        ),
        ...appMenuItems.sublist(3).map((e) => NavigationDrawerDestination(
            icon: Icon(e.icon), label: Text(e.title))),
        Padding(
          padding: const EdgeInsets.only(left: 17.0),
          child: TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.terminate();
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance
                    .signOut()
                    .then((value) => {context.pushReplacement('/')});
              },
              child: Row(
                children: [
                  Icon(
                    Icons.close,
                    color: colors.error,
                  ),
                  Text(
                    "   Cerrar sesión",
                    style: TextStyle(color: colors.error),
                  ),
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
          height: 30,
        )
      ],
    );
  }
}
