import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/presentations/screens/chat/message_field.dart';
import 'package:recuerda_facil/services/services.dart';

import '../../../../features/auth/presentation/providers/providers_auth.dart';

class BoardChatScreen extends ConsumerStatefulWidget {
  final String boardId;
  // final UserAccount currentUser; // UID del usuario principal
  // final UserAccount otherUser; // UID del otro usuario
  static const name = 'board_chat_screen';
  const BoardChatScreen({super.key, required this.boardId});

  @override
  ConsumerState<BoardChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<BoardChatScreen> {
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
  final userACC= ref.watch(authProvider).user;


    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        flexibleSpace: FlexibleSpaceBar(
          background: FutureBuilder(
            future: BoardService().getBoardInfo(widget.boardId),
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final boardInfo = snapshot.data!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        boardInfo['name'],
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Invita personas, Código: ${boardInfo['id']}',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
      //chat
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: BoardService().loadMessages(widget.boardId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error al cargar mensajes del tablero'));
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
                        leading: (message['senderId'] != userActive!.uid)
                            ? CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Colors.transparent,

                                backgroundImage: NetworkImage(message[
                                        'userPhoto'] ??
                                    'https://img.wattpad.com/8f19b412f2223afe4288ed0904120a48b7a38ce1/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f776174747061642d6d656469612d736572766963652f53746f7279496d6167652f5650722d38464e2d744a515349673d3d2d3234323931353831302e313434336539633161633764383437652e6a7067?s=fit&w=720&h=720'),
                              )
                            : null,
                        trailing: (message['senderId'] == userActive.uid)
                            ? CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(message[
                                        'userPhoto'] ??
                                    'https://img.wattpad.com/8f19b412f2223afe4288ed0904120a48b7a38ce1/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f776174747061642d6d656469612d736572766963652f53746f7279496d6167652f5650722d38464e2d744a515349673d3d2d3234323931353831302e313434336539633161633764383437652e6a7067?s=fit&w=720&h=720'),
                              )
                            : null,
                        subtitle: (message['senderId'] != userActive.uid)
                            ? Text(
                                message['displayName'] ?? 'Usuario',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )
                            : null,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                              color: Colors.black54,
                                            ),
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
                                        color:
                                            colors.secondary.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
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

            BoardService()
                .sendMessage(widget.boardId, userACC!.uid!,
                    userACC.displayName!, userACC.photoURL!, value)
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

  
}
