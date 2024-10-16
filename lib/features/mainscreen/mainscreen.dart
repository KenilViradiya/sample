import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiplayer/features/Services/firestore_services.dart';
import 'package:multiplayer/features/gamescreen/game_screen.dart';

import '../gamescreen/game_controller.dart';

class Main_Screen extends StatelessWidget {
  Main_Screen({super.key});


  @override
  Widget build(BuildContext context) {
    final GameContoller gameController = Get.put(GameContoller());
    final gameid = gameController.gameIDGenerate();
    final playerid = gameController.uniqueUserid();
    final services = Firestore_Services(gameid);

    final TextEditingController _gameid = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to the app'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                services.createGame(gameid, playerid);
                Get.to(GameScreen(gameId: gameid,playerId: playerid,));
              },
              child: Text('Create Game')),
          TextField(
            controller: _gameid,
            decoration: InputDecoration(hintText: "Enter the game id"),
          ),
          ElevatedButton(
              onPressed: () {
                services.joinGame(_gameid.text, playerid);
                Get.to(GameScreen(gameId: gameid,playerId: playerid,));
              },
              child: Text("Join Game")),
          ElevatedButton(onPressed: () {}, child: Text('Play Game')),
        ],
      ),
    );
  }
}
