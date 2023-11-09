import 'package:flutter/material.dart';

class BoardScreen extends StatelessWidget {
  static const name = 'board_screen';
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('BoardScreen'),
      ),
      body:  const Center(
        child:  Column(
          children: [
            SizedBox(height: 20,),
            Text('Pronto tableros colaborativos',style: TextStyle(fontSize: 20),),
            SizedBox(height: 10,),
            Icon(Icons.border_all_rounded,size: 100,)
          ],
        ),
      ),
    );
  }
}