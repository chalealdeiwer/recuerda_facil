import 'package:flutter/material.dart';
import 'package:recuerda_facil/presentations/screens/more/more_games/games/tictac/alert_dialog.dart';

class TicTacToeScreen extends StatefulWidget {
  static const name = 'tictac_screen';
  const TicTacToeScreen({Key? key}) : super(key: key);

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  TextStyle customStyle(
          {double fontSize = 16.0,
          // Color color = Colors.white,
          FontWeight fontWeight = FontWeight.normal}) =>
      TextStyle(fontSize: fontSize, fontWeight: fontWeight);
  int scoreX = 0;
  int scoreO = 0;
  bool turnOf = true;
  int filledBox = 0;
  final List<String> boxes = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: (AppBar(
          elevation: 0,
          title: const Text('Tic Tac Toe'),
          // backgroundColor: const Color(0xff3b2763),
          backgroundColor: colors.surfaceVariant,
          actions: [
            IconButton(
                onPressed: () {
                  clearBoard();
                },
                icon: const Icon(Icons.refresh_rounded))
          ],
        )),
        // backgroundColor: const Color(0xff20123c),
        backgroundColor: colors.surfaceVariant,
        body: Column(
          children: [_points(), _board(), _turns()],
          // children: [_points(), _board(), _turns()],
        ));
  }

  Widget _points() {
    return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Jugador O',
                    style: customStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(scoreO.toString(),
                      style:
                          customStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Jugador X',
                    style: customStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(scoreX.toString(),
                      style:
                          customStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ));
  }

  Widget _board() {
    final colors = Theme.of(context).colorScheme;
    return Expanded(
      flex: 3,
      child: GridView.builder(
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _tapAction(index);
            },
            child: Container(
                decoration:
                    BoxDecoration(border: Border.all(width: 2)),
                child: Center(
                    child: Text(
                  boxes[index],
                  style: TextStyle(
                      color: boxes[index] == 'x' ? colors.primary : colors.error,
                      fontSize: 100),
                ))),
          );
        },
      ),
    );
  }

  Widget _turns() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          turnOf ? 'Turno de O' : 'Turno de X',
          style: customStyle(fontSize: 40),
        ));
  }

  void checkWinner() {
    //Valida si es la primera fila
    if (boxes[0] == boxes[1] && boxes[0] == boxes[2] && boxes[0] != '') {
      _showAlert('Ganador', boxes[0]);
      return;
    }

    //Valida si es la segunda fila
    if (boxes[3] == boxes[4] && boxes[3] == boxes[5] && boxes[3] != '') {
      _showAlert('Ganador', boxes[3]);
      return;
    }

    //Valida si es la tercera fila
    if (boxes[6] == boxes[7] && boxes[6] == boxes[8] && boxes[6] != '') {
      _showAlert('Ganador', boxes[6]);
      return;
    }

    //Valida si es la primera columna
    if (boxes[0] == boxes[3] && boxes[0] == boxes[6] && boxes[0] != '') {
      _showAlert('Ganador', boxes[0]);
      return;
    }

    //Valida si es la segunda columna
    if (boxes[1] == boxes[4] && boxes[1] == boxes[7] && boxes[1] != '') {
      _showAlert('Ganador', boxes[1]);
      return;
    }
    //Valida si es la tercera columna
    if (boxes[2] == boxes[5] && boxes[2] == boxes[8] && boxes[2] != '') {
      _showAlert('Ganador', boxes[2]);
      return;
    }

    //Valida diagonal 1
    if (boxes[0] == boxes[4] && boxes[0] == boxes[8] && boxes[0] != '') {
      _showAlert('Ganador', boxes[0]);
      return;
    }
    //Valida diagonal 2
    if (boxes[2] == boxes[4] && boxes[2] == boxes[6] && boxes[2] != '') {
      _showAlert('Ganador', boxes[2]);
      return;
    }

    if (filledBox == 9) {
      _showAlert('Empate', '');
    }
  }

  void _showAlert(String title, String winner) {
    showAlert(
        context: context,
        title: title,
        message: winner == ''
            ? 'La partida fue empate'
            : 'El ganador es ${winner.toUpperCase()}',
        buttonText: 'OK',
        onPressed: () {
          clearBoard();
          Navigator.of(context).pop();
        });

    if (winner == 'o') {
      scoreO++;
    } else if (winner == 'x') {
      scoreX++;
    }
  }

  void _tapAction(int index) {
    setState(() {
      if (turnOf && boxes[index] == '') {
        boxes[index] = 'o';
        filledBox += 1;
      } else if (!turnOf && boxes[index] == '') {
        boxes[index] = 'x';
        filledBox += 1;
      }

      turnOf = !turnOf;
      checkWinner();
    });
  }

  void clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        boxes[i] = '';
      }
    });

    filledBox = 0;
  }
}