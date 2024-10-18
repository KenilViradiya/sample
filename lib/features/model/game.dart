import 'dart:ffi';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GameModel {
  String player1; // Player 1 ID
  String? player2; // Player 2 ID (can be null initially)
  List<String> board; // Game board
  String turn; // Current player's turn
  String? winner; // Winner of the game (can be null)
  int createdAt;
  GameModel({
    required this.player1,
    this.player2,
    required this.board,
    required this.turn,
    this.winner,
    required this.createdAt,
});
  factory GameModel.fromMap(Map<String, dynamic> data) {
    return GameModel(
      player1: data['player1'],
      player2: data['player2'],
      board: List<String>.from(data['board']),
      turn: data['turn'],
      winner: data['winner'],
      createdAt: data['createdAt'],
    );

  }
  Map<String, dynamic> toMap() {
    return {
      'player1': player1,
      'player2': '',
      'board':  List<String?>.filled(9, '').obs
    ,
      'turn': 'player1',
      'winner': winner,
      'createdAt': createdAt,
    };
  }

}