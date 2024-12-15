import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Velha',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<String> board = List.filled(9, ""); // Tabuleiro de jogo
  String currentPlayer = "X"; // Jogador atual
  String winner = ""; // Armazena o vencedor
  bool gameActive = true; // Controla se o jogo ainda está ativo

  void _resetGame() {
    setState(() {
      board = List.filled(9, "");
      currentPlayer = "X";
      winner = "";
      gameActive = true;
    });
  }

  void _handleTap(int index) {
    if (gameActive && board[index] == "") {
      setState(() {
        board[index] = currentPlayer;
        _checkWinner();
        currentPlayer = currentPlayer == "X" ? "O" : "X";
      });
    }
  }

  void _checkWinner() {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] != "" &&
          board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]]) {
        winner = board[pattern[0]];
        gameActive = false;
        break;
      }
    }

    if (gameActive && !board.contains("")) {
      // Empate
      winner = "Empate";
      gameActive = false;
    }
  }

  Widget _buildGridItem(int index) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            board[index],
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Velha'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (context, index) => _buildGridItem(index),
            ),
          ),
          Text(
            gameActive
                ? "Turno: $currentPlayer"
                : (winner == "Empate" ? "Empate!" : "Vencedor: $winner"),
            style: const TextStyle(fontSize: 24),
          ),
          ElevatedButton(
            onPressed: _resetGame,
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }
}
