import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:multiplayer/features/gamescreen/game_controller.dart';
import 'package:multiplayer/features/model/game.dart';

class Firestore_Services {
  DatabaseReference _fb;
  final GameController _gameContoller = Get.put(GameController());

  Firestore_Services(String gameid)
      : _fb = FirebaseDatabase.instance.ref("Games/$gameid");

  Future<String?> createGame( String player1Id) async {
    GameModel newgame = GameModel(
        player1: player1Id,
        player2: null,
        board: List.filled(9, null),
        turn: 'player1',
        winner: null,
        createdAt: 1);
    await _fb.set(newgame.toMap()).then((_) {
      print('Data added for game:  with player: $player1Id');
    }).catchError((error) {
      print('Failed to load data');
    });
  }

  Future<void> joinGame(String gameid, String player2id) async {
    final snapshot = await _fb.get();
    if (snapshot.exists) {
      await _fb.update({
        'player2': player2id,
      }).then((_) {
        print('Player 2 joined game with ID: $gameid');
      }).catchError((error) {
        print('Failed to add player: $error');
      });
    } else {
      print('Game ID: $gameid does not exist.');
    }
  }

  void move(String gameId, int index, String playerId) {
    _fb.get().then((snapshot) {
      if (snapshot.exists) {
        Map<Object?, Object?>? gameData =
            snapshot.value as Map<Object?, Object?>? ?? {};
        List<dynamic> board =
            (gameData?['board'] as List<dynamic>?) ?? List.filled(9, null);

        if (index >= 0 && index < board.length) {
          if (board[index] == null) {
            String currentSymbol =
                (playerId == gameData?['player1']) ? 'X' : 'O';
            board[index] = currentSymbol;
            String nextTurn =
                (playerId == gameData?['player1']) ? 'player2' : 'player1';

            _fb.update({
              'board': board,
              'turn': nextTurn,
              'winner': _gameContoller.checkWinner(board),
            });
          } else {
            print('Cell already occupied.');
          }
        } else {
          print('Invalid index: $index');
        }
      }
    }).catchError((error) {
      print('Failed to get data: $error');
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
