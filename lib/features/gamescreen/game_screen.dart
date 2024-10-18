import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiplayer/features/gamescreen/game_controller.dart';

class GameScreen extends StatelessWidget {
  final String gameid;

  const GameScreen({super.key, required this.gameid});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<GameController>(GameController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Column(
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

                  onTap: () {                     controller.listenToGameUpdates();

                  controller.makeMove(index);
                  }
                   ,
                  // Handle move via Firestore service
                  child: Obx(() =>
                      Container(
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
          Obx(() =>
              Text(
                'Winner: ${controller.winner.value.isNotEmpty ? controller
                    .winner.value : 'None'}',
                style: TextStyle(fontSize: 24),
              )),
          SizedBox(height: 20),
          // Reset game button
          ElevatedButton(
            onPressed: () {
              //  controller.firestore_services.fbservices.resetgame(); // Reset the game on Firebase
              // controller.resetGame(); // Reset local game state
            },
            child: Text('Reset Game'),
          ),
        ],
      ),
    );
  }
}
