import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiplayer/features/Services/firestore_services.dart';
import 'game_controller.dart';

class GameScreen extends StatelessWidget {
  final String gameId;
  final String playerId;
  late final DatabaseReference gameRef;

  GameScreen({required this.gameId, required this.playerId}) {
    gameRef = FirebaseDatabase.instance.ref("Games/$gameId");
  }

  @override
  Widget build(BuildContext context) {
    final GameContoller gameController = Get.put(GameContoller());
    final Firestore_Services firestoreService = Firestore_Services(gameId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: gameRef.onValue,
        builder: (context, snapshot) {
          // Show loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Check if the snapshot has data and if the document exists
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text('Error loading game data.'));
          }

          // Get game data with null safety check
Map<String,dynamic> gameData  = Map<String,dynamic>.from(snapshot.data!.snapshot.value as Map<dynamic,dynamic>);
          print('Game Data: $gameData');

          // Check if both players are present
          if (gameData?['player1'] == null || gameData?['player2'] == null) {
            return Center(child: Text('Waiting for another player to join...'));
          }

          // Extract game data
          List<dynamic> board = gameData?['board'] ?? List.filled(9, null);
          String turn = gameData?['turn'] ?? 'player1';
          String? winner = gameData?['winner'];

          // Update the board in the controller
          gameController.board.assignAll(board.cast<String?>());

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tic Tac Toe Board
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                ),
                shrinkWrap: true,
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Check if the move can be made
                      if (board[index] == null && winner == null) {
                        firestoreService.move(gameId, index, playerId);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          board[index]?.toString() ?? '',
                          style: TextStyle(fontSize: 36),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              // Display the winner
              if (winner != null)
                Text('Winner: $winner', style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              // Reset game button
              ElevatedButton(
                onPressed: () => firestoreService.resetgame,
                child: Text('Reset Game'),
              ),
            ],
          );
        },
      ),
    );
  }
}
