import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GameContoller extends GetxController {
  var board =
      List<String?>.filled(9, null).obs; // Observable list for the game board

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


}
