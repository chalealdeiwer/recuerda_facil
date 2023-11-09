import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GamesScreen extends StatelessWidget {
  static const name = 'games_screen';
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini juegos'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            context.push('/more/games/tic_tac_toe');

          },
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            
            ),
            child: const Column(
              children: [
                SizedBox(height: 20,),
                Text('Tic Tac Toe',style: TextStyle(fontSize: 20),),
                SizedBox(height: 10,),
                Icon(Icons.sentiment_satisfied_alt,size: 100,)
              ],
            ),
          ),
        )
      ),
    );
  }
}