import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:multiplayer/features/gamescreen/game_controller.dart';

class Firestore_Services {
  DatabaseReference _fb;
final GameContoller _gameContoller  = Get.put(GameContoller());
  Firestore_Services(String gameid)
      : _fb = FirebaseDatabase.instance.ref("Games/$gameid");

  Future<String?> createGame(String gameid, String player1Id) async {
    await _fb.set({
      'player1': player1Id,
      'player2': null, // Player 2 joins later
      'board': List.filled(9, null),
      'turn': 'player1',
      'winner': null,
      'createdAt': ServerValue.timestamp, // Use ServerValue for Realtime Database
    }).then((_) {
      print('Data added for game: $gameid with player: $player1Id');
    }).catchError((error) {
      print('Failed to add data: $error');
    });
  }

  Future<void> joinGame(String gameid, String player2id) async {
    await _fb.update({
      'player2': player2id,
    });
  }

  void move(String gameId, int index, String playerId) {
    _fb.get().then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> gameData = snapshot.value as Map<String, dynamic>;
        List<dynamic> board = gameData['board'] ?? List.filled(9, null);

        if (board[index] == null) {
          board[index] = playerId;
          // Update the turn
          String nextTurn = (playerId == gameData['player1'])
              ? 'player2'
              : 'player1';

          // Update in the database
          _fb.update({
            'board': board,
            'turn': nextTurn,
            'winner': _gameContoller.checkWinner(board),
            // Implement a function to check for a winner
          });
        }
      }
    });
  }

  void resetgame() {
    _fb.set({
      'board': List.filled(9, null),
      'turn': 'player1',
      'winner': null,
      'player1': null, // You can pass player1's ID here if needed
      'player2': null,
    });
  }

  Future<Stream<DatabaseEvent>> gameUpdates() async {
    return _fb.onValue;
  }


}
