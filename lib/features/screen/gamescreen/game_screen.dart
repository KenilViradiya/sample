import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiplayer/features/enum/playertype.dart';
import 'game_controller.dart';

class GameScreen extends StatelessWidget {
  final String gameid;
  final PlayerType playerType;
  final GameController controller;

  GameScreen({Key? key, required this.gameid, required this.playerType})
      : controller = Get.put(GameController(gameId: gameid)),
        super(key: key) {
    controller.firestore_services.listenChange(); // Start listening to Firebase changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tic Tac Toe')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return Obx(() {
                  String? symbol = controller.firestore_services.board[index];
                  Color textColor;

                  // Assign colors for symbols
                  if (symbol == 'X') {
                    textColor = Colors.blue;
                  } else if (symbol == 'O') {
                    textColor = Colors.red;
                  } else {
                    textColor = Colors.black;
                  }

                  return GestureDetector(
                    onTap: () {
                      print('Current turn: ${controller.firestore_services.ismyturn.value}');

                      // Check if it's the player's turn
                      if ((playerType == PlayerType.creator &&
                          controller.firestore_services.ismyturn.value) ||
                          (playerType == PlayerType.joiner &&
                              !controller.firestore_services.ismyturn.value)) {
                        controller.firestore_services.ismyturn.value =
                        !controller.firestore_services.ismyturn.value;
                        print('chnage by if ${controller.firestore_services
                            .ismyturn.value}');

                        controller.firestore_services.makeMove(
                            index, playerType);
                        controller.firestore_services
                            .listenChange(); // Listen for turn changes

                      } else {
                        controller.firestore_services
                            .listenChange(); // Listen for turn changes

                        Get.snackbar('Invalid Move', 'Not your turn');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          symbol ?? '', // Display the symbol on the board
                          style: TextStyle(fontSize: 40, color: textColor),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => Text(
            'Turn: ${controller.firestore_services.ismyturn.value ? "Your Turn" : "Opponent\'s Turn"}',
            style: const TextStyle(fontSize: 24),
          )),
          Obx(() => Text(
            'Winner: ${controller.firestore_services.winner.value.isNotEmpty ? controller.firestore_services.winner.value : 'None'}',
            style: const TextStyle(fontSize: 24),
          )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
            controller.firestore_services.resetGame(); // Add reset game functionality if needed
            },
            child: const Text('Reset Game'),
          ),
        ],
      ),
    );
  }
}
