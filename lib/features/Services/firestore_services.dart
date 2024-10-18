import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:multiplayer/features/gamescreen/game_screen.dart';
import 'package:multiplayer/features/model/game.dart';

class Firestore_Services {
  DatabaseReference _fb;

  Firestore_Services(String gameid)
      : _fb = FirebaseDatabase.instance.ref("Games/$gameid");
  RxList<String?> board = List<String?>.filled(9, '').obs;
  String player1idd = '';
  String player2idd = '';

  Future<void> createGame(String player1Id,String gameid) async {
    player1idd = player1Id;
    GameModel newgame = GameModel(
        player1: player1Id,
        player2: '',
        board: List<String>.filled(9, ''),
        turn: 'player1',
        winner: null,
        createdAt: DateTime.now().microsecond);
    await _fb.set(newgame.toMap()).then((_) {
      Get.to(GameScreen(gameid: gameid));

      print('Data added for game:  with player: $player1Id');
    }).catchError((error) {
      print('Failed to load data $error' );
    });
  }

  Future<void> joinGame(String gameid, String player2Id) async {
    player2Id = player2Id;
    DataSnapshot snapshot = await _fb.get();
    if (snapshot.exists) {
      try {
        Map<String, dynamic>? gameData =
            (snapshot.value as Map<Object?, Object?>?)?.cast<String, dynamic>();

        if (gameData != null && gameData['player2'] == '') {
          await _fb.update({
            'player2': player2Id,
          }).then((_) {
            print('Player 2 ($player2Id) has joined the game: $gameid');
            Get.to(GameScreen(
              gameid: gameid,
            ));
          }).catchError((error) {
            print('Failed to join the game: $error');
          });
        } else {
          print('Player 2 has already joined the game.');
        }
      } catch (e) {
        print('Error casting game data: $e');
      }
    } else {
      print('Game not found: $gameid');
    }
  }

  void resetgame() {
    _fb.set({
      'board': List.filled(9, ''),
      'turn': 'player1',
      'winner': null,
      'player1': null, // You can pass player1's ID here if needed
      'player2': null,
    });
  }
}
