import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'game_controller.dart';

class GameScreen extends StatelessWidget {
  final GameController gameController = Get.put(GameController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tic Tac Toe Board
          Expanded(
            child:  GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Check if the move can be made
                    if (gameController.board[index] == null &&
                        gameController.winner.value.isEmpty) {
                      gameController.makeMove(index);
                    } else if (gameController.winner.value.isNotEmpty) {
                      print('Game over! Winner: ${gameController.winner.value}');
                    } else {
                      print('Cell already occupied. Please choose another cell.');
                    }
                  },
                  child: Obx(() => Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: gameController.board[index] == 'X'
                          ? Colors.blue
                          : (gameController.board[index] == 'O'
                          ? Colors.red
                          : Colors.white),
                    ),
                    child: Center(
                      child: Text(
                        gameController.board[index]?.toString() ?? '',
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
          Obx(() {
            if (gameController.winner.value.isNotEmpty) {
              return Text(
                'Winner: ${gameController.winner.value}',
                style: TextStyle(fontSize: 24),
              );
            } else {
              return SizedBox.shrink(); // Display nothing if there's no winner
            }
          }),
          SizedBox(height: 20),
          // Reset game button
          ElevatedButton(
            onPressed: () {
              gameController.resetGame();
              // gameController.resetGame(); // Reset the game
            },
            child: Text('Reset Game'),
          ),
        ],
      ),
    );
  }
}
