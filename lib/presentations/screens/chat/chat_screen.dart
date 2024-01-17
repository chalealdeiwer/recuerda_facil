import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/presentations/screens/chat/message_field.dart';
import 'package:recuerda_facil/services/chat_service.dart';
import 'package:recuerda_facil/services/services.dart';

import '../../../features/auth/presentation/providers/providers_auth.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  // final UserAccount currentUser; // UID del usuario principal
  // final UserAccount otherUser; // UID del otro usuario
  static const name = 'chat_screen';
  const ChatScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController chatScrollController = ScrollController();

  void moveScrollController() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (chatScrollController.hasClients) {
      chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent + 500,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Desplazar al final cuando se añada un nuevo mensaje
      moveScrollController();
    });
    super.initState();
  }

  @override
  void dispose() {
    chatScrollController.dispose();
    super.dispose();
  }

  String formatMessageTime(Timestamp timestamp) {
    DateTime messageTime = timestamp.toDate();
    DateTime now = DateTime.now();

    if (now.day == messageTime.day &&
        now.month == messageTime.month &&
        now.year == messageTime.year) {
      // Formato para el mismo día
      String period = messageTime.hour < 12 ? 'am' : 'pm';
      int hour =
          messageTime.hour > 12 ? messageTime.hour - 12 : messageTime.hour;
      hour = hour == 0 ? 12 : hour; // Si es 0, mostrar 12 en lugar de 0

      return '${hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')} $period';
    } else {
      // Formato para días diferentes
      return '${messageTime.hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')} '
          '${messageTime.day.toString().padLeft(2, '0')}/${messageTime.month.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userActive = ref.watch(authProvider).user;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        //titulo de chat
        title: FutureBuilder(
          future: ChatService()
              .getOtherUserIdInChat(widget.chatId, userActive!.uid!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Chat no existe.');
            } else {
              return FutureBuilder(
                future: getUser(snapshot.data.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Text('Usuario no encontrado.');
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data!.photoURL!),
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("${snapshot.data!.displayName}"),
                      ],
                    );
                  }
                },
              );
            }
          },
        ), // Puedes mostrar el nombre del otro usuario aquí
      ),
      //chat
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: ChatService().loadMessages(widget.chatId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar mensajes'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 10,
                  );
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // Desplazar al final cuando se añada un nuevo mensaje
                  moveScrollController();
                });

                final messages = snapshot.data?.docs ?? [];

                return ListView.builder(
                  controller: chatScrollController,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final messageText = message['message'] ?? '';
                    final formattedTime =
                        formatMessageTime(message['timestamp']);
                    return ListTile(
                        onLongPress: () {},
                        title: (message['senderId'] == userActive.uid)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: colors.primary.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          child: Text(
                                            messageText,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            
                                            formattedTime,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black54,  ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  )
                                ],
                              )
                            // Otros detalles del mensaje como el remitente, la hora, etc.
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: colors.secondary.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          child: Text(
                                            messageText,
                                            style: const TextStyle(
                                                fontSize: 20, color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            formattedTime,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black54),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ));
                  },
                );
              },
            ),
          ),
          MessageFieldBox(onTap: () {
            moveScrollController();
          },
              // onValue: (value) {
              //   chatProvider.sendMessage(value);
              // },
              onValue: (value) {
            if (value.isEmpty) return;

            ChatService()
                .sendMessage(widget.chatId, userActive.uid!, value)
                .then((value) =>
                    moveScrollController()); // Llamar al método para enviar el mensaje
          })
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () =>
      //       _showMessageDialog(context, widget.chatId, userActive.uid!),
      //   child: const Icon(Icons.add),
      // )
    );
  }

  void _showMessageDialog(BuildContext context, chatId, senderId) {
    final TextEditingController _messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enviar mensaje'),
          content: TextField(
            controller: _messageController,
            decoration: const InputDecoration(hintText: 'Escribe tu mensaje'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ChatService().sendMessage(
                    chatId,
                    senderId,
                    _messageController
                        .text); // Llamar al método para enviar el mensaje
                _messageController.clear(); // Limpiar el campo de texto
              },
              child: const Text('Enviar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void createChat(String currentUserUid, String otherUserUid) {
    // Aquí deberías implementar la lógica para iniciar un chat o enviar un mensaje
    // Podrías utilizar tu servicio ChatService o Firestore para realizar acciones de chat

    // Ejemplo básico de cómo podrías imprimir los UIDs para verificar la lógica
    print('Chat iniciado entre $currentUserUid y $otherUserUid');
  }
}
