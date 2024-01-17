import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/features/auth/domain/entities/user_account.dart';
import 'package:recuerda_facil/features/auth/presentation/providers/providers_auth.dart';
import 'package:recuerda_facil/services/user_services.dart';

import '../../../services/services.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  static const name = 'community_screen';
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<CommunityScreen> {
  bool posting = false;

  void pressedButton(userActive, user) async {
    setState(() {
      posting = true;
    });
    String chatId = await ChatService()
        .createChat(userActive.uid.toString(), user.uid.toString());
    context.push('/more/chats/chat/$chatId');
    setState(() {
      posting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    final userActive = ref.watch(authProvider).user;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Personas'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(
              "Encuentra personas que son parte de Recuerda Fácil",
              style: textStyle.titleLarge,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Expanded(
              child: FutureBuilder<List<UserAccount>>(
                future: getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No hay usuarios disponibles.'));
                  } else {
                    List<UserAccount> users = snapshot.data!.where((element) {
                      return element.private == false;
                    }).toList();

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        UserAccount user = users[index];
                        String? photoURL = user.photoURL;
                        return ListTile(
                            leading: CircleAvatar(
                              // radius: 0,

                              backgroundColor: colors.surface,
                              backgroundImage: (photoURL == "Sin foto")
                                  ? const AssetImage(
                                      'assets/images/userphoto.png')
                                  : NetworkImage(photoURL!) as ImageProvider,
                              onBackgroundImageError: (exception, stackTrace) =>
                                  const Icon(Icons.account_circle),
                            ),
                            title: Text(
                              user.displayName ?? 'Sin nombre',
                              style: textStyle.titleLarge,
                            ),
                            subtitle: (user.uid == userActive!.uid.toString())
                                ? Text(
                                    "Tú (${user.email})",
                                    style: textStyle.titleMedium,
                                  )
                                : const Text(""),

                            // subtitle: Text(user['email'] ?? 'Sin email'),
                            onTap: () {
                              showModalBottomSheet(
                                barrierColor: colors.surface.withOpacity(0.5),
                                context: context,
                                builder: (context) {
                                  return Container(
                                    width: double.infinity,
                                    height: size.height * 0.3,
                                    // Diseño del contenido emergente
                                    padding: const EdgeInsets.all(16.0),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 60,
                                          child: Container(
                                            height: size.height * 0.25,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10.0)),
                                              color: Colors
                                                  .grey, // color por defecto si no hay imagen
                                              image: DecorationImage(
                                                image: NetworkImage(user
                                                        .coverPhotoURL ??
                                                    'https://images.unsplash.com/photo-1612837017391-5e9b5f0b0b0f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Y29tbXVuaXR5JTIwY29udGVudHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 80,
                                          right: 0,
                                          left: 0,
                                          bottom: 0,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                // backgroundColor: Colors.grey,
                                                radius: 40,
                                                backgroundImage: NetworkImage(
                                                    user.photoURL!),
                                                backgroundColor: Colors.grey,
                                              ),
                                              const SizedBox(height: 20),
                                              // Otros detalles del usuario
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 10,
                                          child: Row(
                                            children: [
                                              Text(
                                                  user.displayName ??
                                                      'Sin nombre',
                                                  style: textStyle.titleLarge),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              if (userActive.uid.toString() !=
                                                  user.uid.toString())
                                                FilledButton(
                                                  onPressed: posting
                                                      ? null
                                                      : () async {
                                                          pressedButton(
                                                              userActive, user);
                                                        },
                                                  child: const Row(
                                                    children: [
                                                      Text("Iniciar Chat "),
                                                      Icon(Icons.chat),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            });
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }
}
