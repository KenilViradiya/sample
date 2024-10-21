import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:multiplayer/player_type.dart';

import '../../Services/firestore_services.dart';


class GameController extends GetxController {
  final String gameId;

  GameController({ required this.gameId});

  late final Firestore_Services firestore_services;
  var board = List<String?>.filled(9, '').obs;
  RxString symbol = ''.obs;
  RxString turn = ''.obs;

  // Store the current player ID
  var winner = ''.obs;

  final DatabaseReference databaseRef =
      FirebaseDatabase.instance.ref(); // Updated reference

  bool isMyTurn = false;

  @override
  void onInit() {
    firestore_services = Firestore_Services(gameId);
    super.onInit();
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
    final DatabaseReference gameRef =
        FirebaseDatabase.instance.ref("Games/$gameId");
    gameRef.onChildAdded.listen((event) {
      if (event.snapshot.exists) {
        Map<String, dynamic> gameData =
            (event.snapshot.value as Map<Object?, Object?>)
                .cast<String, dynamic>();
        print('$gameData');
        // Update the current turn and board state
        turn.value = gameData['turn'];
        print('current player $turn');
        board.assignAll((gameData['board'] as List<dynamic>).cast<String?>());
      }
    });
  }

  Future<void> makeMove(int index) async {
    if (board[index] == '') {
        board[index] = 'X'; // Player 1's symbol
        await updateGame();}
      else {
        print('It is not your turn!');


  }}
  Future<void> updateGame() async {
    // Update the game in Firebase
    await databaseRef.child("Games/$gameId").update({
      'board': board,
      'turn': turn.value == 'player1' ? 'player2' : 'player1', // Switch turn
    }).then((_) {
      print("Board and turn updated successfully.");
      // Update isMyTurn based on the new turn
    }).catchError((error) {
      print("Failed to update board and turn: $error");
    });
  }
}
