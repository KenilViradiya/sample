import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GameController extends GetxController {
  RxList<String?> board = List<String?>.filled(9, null).obs;
  var turn = 'X'.obs; // Reactive turn
  var winner = ''.obs; // Reactive winner

  void updateGameData(Map<String, dynamic> gameData) {
    board.assignAll(gameData['board']?.cast<String?>() ?? List.filled(9, null));
    turn.value = gameData['turn'] ?? 'player1';
    winner.value = gameData['winner'] ?? '';
  } // Observable list for the game board
void resetGame()
{
  board.assignAll(List<String?>.filled(9,null));
  winner.value = '';
  turn.value =  'X';
}
  String uniqueUserid() {
    return FirebaseFirestore.instance.collection('Games').doc().id;
  }

  String gameIDGenerate() {
    String newGameId;

    final Set<String> _existingGameIds = {}; // Set to track existing game IDs

    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    do {
      newGameId = List.generate(
          5, (index) => characters[random.nextInt(characters.length)]).join();
    } while (_existingGameIds.contains(newGameId));
    _existingGameIds.add(newGameId);
    return newGameId;
  }

  String? checkWinner(List<dynamic> board) {
    const winningConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningConditions) {
      if (board[combination[0]] != null &&
          board[combination[0]] == board[combination[1]] &&
          board[combination[0]] == board[combination[2]]) {
        return board[combination[0]]; // Return the winner ('X' or 'O')
      }
    }
    return board.contains(null)
        ? null
        : 'Draw'; // Return 'Draw' if no empty spaces
  }
  void makeMove(int index)
  {
    if (board[index] == null && winner.value.isEmpty) {
      board[index] =  turn.value;
      winner.value = checkWinner(board)?? '';
      turn.value = turn.value == 'X' ? 'O' : 'X'; // Switch turns

    }
  }
}
