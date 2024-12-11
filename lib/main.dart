import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<String> board = List.filled(9, ''); // Tabuleiro vazio
  String currentPlayer = 'X'; // Jogador inicial
  String message = ''; // Mensagem do jogo (vencedor ou empate)
  bool isHumanOpponent = true; // Alternador para "Humano" ou "Computador"

  // Manipula o toque em uma célula
  void _handleTap(int index) {
    if (board[index] == '' && message == '') {
      setState(() {
        board[index] = currentPlayer;

        if (_checkWinner()) {
          message = '$currentPlayer venceu!';
        } else if (!board.contains('')) {
          message = 'Empate!';
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';

          if (!isHumanOpponent && currentPlayer == 'O') {
            _computerMove();
          }
        }
      });
    }
  }

  // Jogada do computador (movimento aleatório)
  void _computerMove() {
    Future.delayed(Duration(milliseconds: 500), () {
      // Aguarda meio segundo para simular o pensamento do computador
      setState(() {
        List<int> emptyCells = [];
        for (int i = 0; i < board.length; i++) {
          if (board[i] == '') emptyCells.add(i);
        }

        if (emptyCells.isNotEmpty) {
          int randomIndex = emptyCells[Random().nextInt(emptyCells.length)];
          board[randomIndex] = currentPlayer;

          if (_checkWinner()) {
            message = '$currentPlayer venceu!';
          } else if (!board.contains('')) {
            message = 'Empate!';
          } else {
            currentPlayer = 'X'; // Volta para o humano
          }
        }
      });
    });
  }

  // Verifica se há um vencedor
  bool _checkWinner() {
    List<List<int>> winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Linhas
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Colunas
      [0, 4, 8], [2, 4, 6]             // Diagonais
    ];

    for (var combo in winningCombinations) {
      if (board[combo[0]] == currentPlayer &&
          board[combo[0]] == board[combo[1]] &&
          board[combo[1]] == board[combo[2]]) {
        return true;
      }
    }
    return false;
  }

  // Reinicia o jogo
  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      message = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Velha'),
        centerTitle: true,
        backgroundColor: Colors.purple[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Alternador "Humano" ou "Computador"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Switch(
                  value: isHumanOpponent,
                  onChanged: (value) {
                    setState(() {
                      isHumanOpponent = value;
                      _resetGame(); // Reinicia o jogo ao alternar
                    });
                  },
                ),
                Text(
                  isHumanOpponent ? "Humano" : "Computador",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Tabuleiro com fundo azul claro e bordas arredondadas
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255), // Fundo azul claro
                borderRadius: BorderRadius.circular(16), // Bordas arredondadas
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              padding: EdgeInsets.all(8),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: 9,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => _handleTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 199, 235, 254), // Fundo branco das células
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8), // Bordas arredondadas
                    ),
                    child: Center(
                      child: Text(
                        board[index],
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Mensagem de status
            Text(
              message,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Botão "Reiniciar Jogo"
            ElevatedButton(
              onPressed: _resetGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Fundo do botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Bordas arredondadas
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'Reiniciar Jogo',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}