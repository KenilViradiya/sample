import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Services/firestore_services.dart';
import 'controllers/main_controller.dart';


class Main_Screen extends StatelessWidget {
  Main_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    final TextEditingController _gameid = TextEditingController(); // Controller for game ID input
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to the app'),
      ),
      body: Column(
        children: [
          // Button to create a new game
          ElevatedButton(
            onPressed: () {
              final gameid = controller.gameIDGenerate(); // Generate a new game ID
              final services = Firestore_Services(gameid!);

              services.createGame(gameid);
            },
            child: Text('Create Game'),
          ),
          // TextField to input the game ID to join an existing game
          TextField(
            controller: _gameid,
            decoration: InputDecoration(hintText: "Enter the game id"),
          ),
          // Button to join an existing game
          ElevatedButton(
            onPressed: () {
              final enteredGameId = _gameid.text.trim(); // Get the entered game ID
              if (enteredGameId.isNotEmpty) {
                final services = Firestore_Services(enteredGameId); // Initialize Firestore service with the entered game ID

                services.joinGame(enteredGameId); // Join game as player2
                print('Player joined game with ID: $enteredGameId');
                // Get.to(GameScreen(gameId: enteredGameId, playerId: playerid)); // Navigate to game screen
              } else {
                print('Please enter a valid game ID');
              }
            },
            child: Text("Join Game"),
          ),
        ],
      ),
    );
  }
}
