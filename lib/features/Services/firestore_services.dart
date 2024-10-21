import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:multiplayer/features/screen/gamescreen/game_screen.dart';
import 'package:multiplayer/features/screen/login/controller.dart';

class Firestore_Services {
  DatabaseReference _fb;

  Firestore_Services(String gameid)
      : _fb = FirebaseDatabase.instance.ref("Games/$gameid");

  final controller = Get.put(Login_controller());

  RxString gameStatus = 'Waiting for Player 1'.obs;
  RxString currentplayer = ''.obs;

  // Method to create a new game
  Future<void> createGame(String gameid) async {
    await _fb.set({
      'player1': controller.userid.value,
      'player2': '',
      'board': List<String>.filled(9, ''),
      'turn': 'player1',
      'winner': null,
      'createdAt': DateTime.now().minute,
    }).then((_) {
      checkStatus(gameid);

      Get.to(GameScreen(gameid: gameid));

    }).catchError((error) {
      print('Failed to create game: $error');
    });
  }
  // Method to join the game
  Future<void> joinGame(String gameid) async {
    DataSnapshot snapshot = await _fb.get();
    if (snapshot.exists) {
      Map<String, dynamic>? gameData =
          (snapshot.value as Map<Object?, Object?>?)?.cast<String, dynamic>();

      if (gameData != null && gameData['player2'] == '') {
        await _fb
            .update({
              'player2': controller.userid.value,
            })
            .then((_) {})
            .catchError((error) {
              print('Failed to join the game: $error');
            });
      }
    }
  }

  // Method to check game status and return appropriate message
  checkStatus(String gameid) async {
    DataSnapshot snapshot = await _fb.get();

    if (snapshot.exists) {
      Map<String, dynamic>? gameData =
          (snapshot.value as Map<Object?, Object?>?)?.cast<String, dynamic>();

      if (gameData != null) {
        if (gameData['player1'] != null && gameData['player2'] == '') {
          currentplayer.value = gameData['player1'];
          print('current player $currentplayer');
          gameStatus.value = "Waiting for Player 2...";
          print('$gameStatus');
        } else if (gameData['player1'] != null && gameData['player2'] != null) {
          gameStatus.value = "Both players have joined. Game is ready!";
          print('$gameStatus');

        }
      }
    } else {
      gameStatus.value = "Game not found!";
    }
  }

// Return a Text widget that observes changes in game status
}
