import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();

  // List<Message> messagesList = [
    // Message(text: 'Hola amor!', fromwho: Fromwho.me),
    // Message(text: 'Ya regresaste del trabajo?', fromwho: Fromwho.me),
  // ];

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;
    // final newMessage = Message(text: text, fromwho: Fromwho.me);
    // messagesList.add(newMessage);

    if(text.endsWith('?')){
      await herReply();
    }
    notifyListeners();
    moveScrollController();
  }

  Future<void> herReply() async{
    // final herMessage = await getYesNoAnswer.getAnswer();
    // messagesList.add(herMessage);
    notifyListeners();
    moveScrollController();
    
  }
  void moveScrollController()async{
    await Future.delayed(const Duration(milliseconds: 100));
    chatScrollController.animateTo(
      
      chatScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}