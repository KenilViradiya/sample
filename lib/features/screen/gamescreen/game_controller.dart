import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:multiplayer/features/screen/login/controller.dart';
import 'package:multiplayer/player_type.dart';

import '../../Services/firestore_services.dart';


class GameController extends GetxController {
  final String gameId;

  GameController({ required this.gameId});

  late final Firestore_Services firestore_services;


  // Store the current player ID
  var winner = ''.obs;

  final DatabaseReference databaseRef =
      FirebaseDatabase.instance.ref(); // Updated reference


  @override
  void onInit() {
    firestore_services = Firestore_Services(gameId);
    super.onInit();
  }






}
