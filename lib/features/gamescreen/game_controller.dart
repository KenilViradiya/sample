import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../Services/firestore_services.dart';

class GameController extends GetxController {
  late final Firestore_Services firestore_services;
  var board = List<String?>.filled(9, '').obs;
  RxString symbol = ''.obs;
  RxString  turn = ''.obs;
  RxString currentturn = 'player1'.obs;

  // Store the current player ID
  var winner = ''.obs;
  var gameid = '';
  final DatabaseReference databaseRef =
  FirebaseDatabase.instance.ref(); // Updated reference
  String gameIDGenerate() {
    final Set<String> _existingGameIds = {}; // Set to track existing game IDs

    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    do {
      gameid = List.generate(
          5, (index) => characters[random.nextInt(characters.length)]).join();
    } while (_existingGameIds.contains(gameid));
    _existingGameIds.add(gameid);
    print("Game create $gameid");
    return gameid;
  }

  @override
  void onInit() {
    firestore_services = Firestore_Services(gameid);
    super.onInit();
  }


  String uniqueUserid() {
    return FirebaseFirestore.instance
        .collection('Games')
        .doc()
        .id;
  }

  bool checkWinner(List<dynamic> board) {
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
        return true; // Return the winner ('X' or 'O')
      }
    }
    return false;
  }
  void listenToGameUpdates() {
    final DatabaseReference gameRef = FirebaseDatabase.instance.ref("Games/$gameid");

    gameRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<String, dynamic> gameData = (event.snapshot.value as Map<Object?, Object?>).cast<String, dynamic>();
print('$gameData');
        // Update the current turn and board state
        turn.value = gameData['turn'] ;
        print('current player $turn');
        board.assignAll((gameData['board'] as List<dynamic>).cast<String?>());

      }
    });
  }

  void makeMove(int index) {
    // Ensure the move is valid: check if the index is empty and if it's the current player's turn
    if (board[index] == '' ) {
      // Check if it's the correct player's turn
      if (turn.value == 'player1' && currentturn.value == 'player1Id') {
        board[index] = 'X'; // Player 1's symbol
        updateGame();
      } else if (turn.value == 'player2' && currentturn.value == 'player2Id') {
        board[index] = 'O'; // Player 2's symbol
        updateGame();
      } else {
        print('It is not your turn!');
      }
    } else {
      print('Invalid move.');
    }
  }

  void updateGame() {
    // Update the game in Firebase
    databaseRef.child("Games/$gameid").update({
      'board': board,
      'turn': turn.value == 'player1' ? 'player2' : 'player1', // Switch turn
    }).then((_) {
      print("Board and turn updated successfully.");
    }).catchError((error) {
      print("Failed to update board and turn: $error");
    });
  }



}


