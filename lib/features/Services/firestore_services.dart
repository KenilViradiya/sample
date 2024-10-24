import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:multiplayer/features/enum/playertype.dart';
import 'package:multiplayer/features/screen/gamescreen/game_screen.dart';
import 'package:multiplayer/features/screen/login/controller.dart';

class Firestore_Services extends GetxController {
  DatabaseReference _fb;
  final controller = Get.put(Login_controller());

  Firestore_Services(String gameid)
      : _fb = FirebaseDatabase.instance.ref("Games/$gameid");

  RxList board = List<String?>.filled(9, '').obs;
  RxString symbol = ''.obs;
  RxString winner = ''.obs;
  RxBool ismyturn = false.obs;

  // Create a new game
  Future<void> createGame(String gameid) async {
    await _fb.set({
      'player1': controller.userid.value,
      'player2': '',
      'board': List<String>.filled(9, ''),
      'winner': null,
      'turn': ismyturn.value,
      'createdAt': DateTime.now().minute,
    }).then((_) {
resetGame();
      Get.to(GameScreen(
        gameid: gameid,
        playerType: PlayerType.creator,
      ));
      print('Game created with ID: $gameid');
    });
  }

  // Join an existing game
  Future<void> joinGame(String gameid) async {
    DataSnapshot snapshot = await _fb.get();
    if (snapshot.exists) {
      Map<String, dynamic>? gameData =
      (snapshot.value as Map<Object?, Object?>?)?.cast<String, dynamic>();

      if (gameData != null && gameData['player2'] == '') {
        await _fb.update({'player2': controller.userid.value});
        Get.to(GameScreen(
          gameid: gameid,
          playerType: PlayerType.joiner,
        ));
resetGame();      }
    }
  }

  // Listen for turn changes from Firebase
  void listenturn()
  {
    _fb.child('turn').onValue.listen((event) {
      if (event.snapshot.exists) {
        bool turn = event.snapshot.value as bool;
        ismyturn.value = turn;  // Update turn
        print('Turn change detected: ${ismyturn.value}');
      }
    });
  }
  void listenChange() {
    _fb.child('turn').onValue.listen((event) {
      if (event.snapshot.exists) {
        bool turn = event.snapshot.value as bool;
        ismyturn.value = turn;  // Update turn
        print('Turn change detected: ${ismyturn.value}');
      }
    });
    _fb.child('board').onValue.listen((event) {
      if (event.snapshot.exists) {
        List<dynamic>? boardData = event.snapshot.value as List<dynamic>?;
        if (boardData != null) {
          board.value = boardData.cast<String?>();
          checkWinner();

          // Check for a winner after every board update
        }
      }
    });
  }

  // Make a move and update the board and turn in Firebase
  Future<void> makeMove(int index, PlayerType playerType) async {
    try {
      String symbol = playerType == PlayerType.creator ? 'X' : 'O';

      // Update the board and turn in Firebase
      await _fb.update({
        'board/$index': symbol, // Update the symbol on the board
        'turn': ismyturn.value // Toggle the turn value
      });

      print('Move made at index $index with symbol $symbol');
    } catch (error) {
      print('Error making move in database: $error');
    }
  }

  void checkWinner() {
    List<List<int>> winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],  // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8],  // Columns
      [0, 4, 8], [2, 4, 6]              // Diagonals
    ];

    for (var combination in winningCombinations) {
      String? a = board[combination[0]];
      String? b = board[combination[1]];
      String? c = board[combination[2]];

      if (a != '' && a == b && a == c) {
        winner.value = a!;  // Set the winner ('X' or 'O')
        _fb.update({'winner': winner.value});  // Update winner in Firebase
        print('Winner found: ${winner.value}');

          resetGame(); // Automatically reset the game after a short delay
      }
    }

    // Check for a draw (if all cells are filled and no winner)
    if (!board.contains('')) {
      winner.value = 'Draw';
      _fb.update({'winner': 'Draw'});  // Update draw in Firebase
      print('The game is a draw');
    }
  }
  Future<void> resetGame() async {
    try {
      await _fb.update({
        'board': List<String>.filled(9, ''), // Reset the board to empty
        'turn': true, // Reset turn to Player 1 (you can adjust this if needed)
        'winner': null, // Clear the winner
      });

      // Reset the local state as well
     clear();
      print('Game reset successfully.');
    } catch (e) {
      print('Error resetting game: $e');
    }
  }
  void clear()
  {board.value = List<String?>.filled(9, '');
  ismyturn.value = true; // Set the turn to the first player
  winner.value = ''; // Clear the winner locally
  }



}


