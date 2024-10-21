import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
DatabaseReference databaseRef = FirebaseDatabase.instance.ref().child("Games");

class MainController extends GetxController{
  // String?  gameIDGenerate()  {
  //   return databaseRef.push().key;
  //
  // }


  String?  gameIDGenerate() {
  final Set<String> generatedCodes = {}; // Set to store unique codes
  final Random random = Random();
  final String letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  // Function to generate a unique 5-letter random code

  String code;

  do {
  code = List.generate(5, (index) => letters[random.nextInt(letters.length)]).join();
  } while (generatedCodes.contains(code)); // Ensure the code is unique

  generatedCodes.add(code); // Add the new unique code to the set
  return code;
  }
  }

