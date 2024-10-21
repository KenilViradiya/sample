import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiplayer/features/Services/firestore_services.dart';

import 'game_controller.dart';

class GameScreen extends StatelessWidget {
  final String gameid;

  const GameScreen({
    super.key,
    required this.gameid,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<GameController>(GameController(gameId: gameid));
 final sevices  =  Get.put(Firestore_Services(gameid));
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Obx(() {
        // Check if player2 has joined the game
        if (sevices.gameStatus.value != "Both players have joined. Game is ready!") {
          // Show waiting message until player 2 joins
          return Center(
            child: Text(
              sevices.gameStatus.value,
              style: TextStyle(fontSize: 24),
            ),
          );
        } else {
          // If both players have joined, show the game board
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tic Tac Toe Board
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        // Add your logic to handle player moves
                        // Example:
                        // if (controller.isMyTurn) {
                        //   await controller.makeMove(index);
                        // }
                      },
                      child: Obx(() => Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: controller.board[index] == 'X'
                              ? Colors.blue
                              : (controller.board[index] == 'O'
                              ? Colors.red
                              : Colors.white),
                        ),
                        child: Center(
                          child: Text(
                            controller.board[index] ?? '',
                            style: TextStyle(fontSize: 36),
                          ),
                        ),
                      )),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              // Display the winner
              Obx(() => Text(
                'Winner: ${controller.winner.value.isNotEmpty ? controller.winner.value : 'None'}',
                style: TextStyle(fontSize: 24),
              )),
              SizedBox(height: 20),
              // Reset game button
              ElevatedButton(
                onPressed: () {
                  // Add your logic to reset the game
                },
                child: Text('Reset Game'),
              ),
            ],
          );
        }
      }),
    );
  }
}
