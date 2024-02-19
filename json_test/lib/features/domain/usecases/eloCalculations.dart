//import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:json_test/features/domain/entities/fight.dart';
import 'package:json_test/features/domain/entities/fight.dart';
import 'package:json_test/features/domain/entities/fighter.dart';
import 'dart:math';

class eloCalculator{


    /*
      gameResult == 1.0  // win
      gameResult == 0.5  // draw
      gameResult == 0.0  // loss
      fighterElo is the elo of who the function is currently be appplied to, not their opponent

      winnerEntity.elo![winnerEntity.elo!.length - 1]
      and
      loserEntity.elo![loserEntity.elo!.length - 1]
      both get the most recent elo rating that the fighter has had

    */
  int calculateNewRating(double gameResult, double expectedScore, double kFactor, int fighterElo, FighterEntity fighter) {
      int newRating = fighterElo + (kFactor * (gameResult - expectedScore)).toInt();
      //fighter.elo!.add(newRating); // ! says that fighter.elo can't be null
      
      return newRating;
    }

  //fighterElo is the elo of who the function is currently be appplied to, not their opponent
  double getExpectedScore(int opponentRating, int fighterElo) { // is opponent rating the opponent's elo?
      return 1.0 / (1.0 + pow(10.0, ((opponentRating - fighterElo).toDouble() / 400.0)));
  }


  void setNewRating(String winner, String r_fighter, String b_fighter, Map<String,FighterEntity> fighterHashMap) {
        
    double kFactor = 20.0;
    double expectedScore = 0.0;
    int winnerNewRating = 0;
    int loserNewRating = 0;
    
    if (fighterHashMap[r_fighter] == null) {
      print("FIGHTER NOT FOUND R: ${r_fighter} -- ${fighterHashMap[r_fighter]}");
      return;
    }
     
    if (fighterHashMap[b_fighter] == null) {
      print("FIGHTER NOT FOUND B: ${b_fighter} -- ${fighterHashMap[b_fighter]}");
      return;
    }

    String winnerStr = winner == "Red" ? r_fighter : b_fighter;
    String loserStr = winner == "Red" ? b_fighter : r_fighter;
    FighterEntity winnerEntity = fighterHashMap[winnerStr]!;
    FighterEntity loserEntity = fighterHashMap[loserStr]!;

    winnerEntity.wins = (winnerEntity.wins ?? 0) + 1;  // Increment wins if winnerEntity is not null
    fighterHashMap[winnerStr] = winnerEntity;

    // update loser's record
    loserEntity.losses = (loserEntity.losses ?? 0) + 1;      
    fighterHashMap[loserStr] = loserEntity;


    //setting new rating for winner, which is red
    kFactor = (winnerEntity.elo![winnerEntity.elo!.length - 1] > 2500) ? 15.0 : 20.0;
    expectedScore = getExpectedScore(loserEntity.elo![loserEntity.elo!.length - 1],winnerEntity.elo![winnerEntity.elo!.length - 1]);

    winnerNewRating = calculateNewRating(1.0, expectedScore, kFactor, winnerEntity.elo![winnerEntity.elo!.length - 1], winnerEntity);
    //winnerEntity.elo!.add(newRating); // this affects getExpectedScore when it's called for the loser

    //setting new rating for loser, which is blue
    kFactor = (loserEntity.elo![loserEntity.elo!.length - 1] > 2500) ? 15.0 : 20.0;
    expectedScore = getExpectedScore(winnerEntity.elo![winnerEntity.elo!.length - 1],loserEntity.elo![loserEntity.elo!.length - 1]);
    
//was always putting 1.0 into the calculate new rating, so the model thought everyone was winning
    loserNewRating = calculateNewRating(0.0, expectedScore, kFactor, loserEntity.elo![loserEntity.elo!.length - 1], loserEntity);
    
    winnerEntity.elo!.add(winnerNewRating);
    loserEntity.elo!.add(loserNewRating);
  
  
// check for a specific fighter and add a breakpoint to check that you're not repeating fights, that you're not adding fake or duplicate fights
// 
// //     if(winner == "Red"){
//       FighterEntity winnerEntity = fighterHashMap[r_fighter]!; // the exclamation point tells dart that this value is not going to be null.
//       
// //       // error: b fighter is not found in hashMap
//       FighterEntity loserEntity = fighterHashMap[b_fighter]!;
//       
// //       //update winner's record
// //       winnerEntity.wins = (winnerEntity.wins ?? 0) + 1;  // Increment wins if winnerEntity is not null
//       fighterHashMap[r_fighter] = winnerEntity;
// 
// // // update loser's record
// //       loserEntity.losses = (loserEntity.losses ?? 0) + 1;      
//       fighterHashMap[b_fighter] = loserEntity;

// 
// // //setting new rating for winner, which is red
// //       kFactor = (winnerEntity.elo![winnerEntity.elo!.length - 1] > 2500) ? 15.0 : 20.0;
//       expectedScore = getExpectedScore(loserEntity.elo![loserEntity.elo!.length - 1],winnerEntity.elo![winnerEntity.elo!.length - 1]);
// 
// //       newRating = calculateNewRating(1.0, expectedScore, kFactor, winnerEntity.elo![winnerEntity.elo!.length - 1], winnerEntity);
//       winnerEntity.elo!.add(newRating); 
// 
// // //setting new rating for loser, which is blue
// //       kFactor = (loserEntity.elo![loserEntity.elo!.length - 1] > 2500) ? 15.0 : 20.0;
//       expectedScore = getExpectedScore(winnerEntity.elo![winnerEntity.elo!.length - 1],loserEntity.elo![loserEntity.elo!.length - 1]);
// 
// //       newRating = calculateNewRating(1.0, expectedScore, kFactor, loserEntity.elo![loserEntity.elo!.length - 1], loserEntity);
//       loserEntity.elo!.add(newRating); 
   
// 
//     }
// 
// //     else if(winner == "Blue"){
// //       FighterEntity winnerEntity = fighterHashMap[b_fighter]!;
//       FighterEntity loserEntity = fighterHashMap[r_fighter]!;
//       
// //       // update winner's record
// //       winnerEntity.wins = (winnerEntity.wins ?? 0) + 1;
// //       // Update the fighterHashMap with the modified entity
//       fighterHashMap[b_fighter] = winnerEntity;
// 
// //       // update loser's record
// //       loserEntity.losses = (loserEntity.losses ?? 0) + 1;
// //       // Update the fighterHashMap with the modified entity
//       fighterHashMap[b_fighter] = loserEntity; // ****Big bug lol

// 
// // //setting new rating for winner, which is blue
// //       kFactor = (winnerEntity.elo![winnerEntity.elo!.length - 1] > 2500) ? 15.0 : 20.0;
//       expectedScore = getExpectedScore(loserEntity.elo![loserEntity.elo!.length - 1],winnerEntity.elo![winnerEntity.elo!.length - 1]);
// 
// //       newRating = calculateNewRating(1.0, expectedScore, kFactor, winnerEntity.elo![winnerEntity.elo!.length - 1], winnerEntity);
//       winnerEntity.elo!.add(newRating); 
// 
// // //setting new rating for loser, which is red
// //       kFactor = (loserEntity.elo![loserEntity.elo!.length - 1] > 2500) ? 15.0 : 20.0;
//       expectedScore = getExpectedScore(winnerEntity.elo![winnerEntity.elo!.length - 1],loserEntity.elo![loserEntity.elo!.length - 1]);
// 
// //       newRating = calculateNewRating(1.0, expectedScore, kFactor, loserEntity.elo![loserEntity.elo!.length - 1], loserEntity);
//       loserEntity.elo!.add(newRating); 
//    
// //     }
    //TODO: conditionals for draws, DQs,  no contests. DQs and no contests might be the same thing, need to look into that.

     
    
  

  

    }

}