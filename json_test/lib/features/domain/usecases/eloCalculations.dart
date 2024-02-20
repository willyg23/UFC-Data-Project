//import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:json_test/features/domain/entities/fight.dart';
import 'package:json_test/features/domain/entities/fight.dart';
import 'package:json_test/features/domain/entities/fighter.dart';
import 'dart:math';

class eloCalculator{

    /*
      notes:
      
      gameResult == 1.0  // win
      gameResult == 0.5  // draw
      gameResult == 0.0  // loss
      fighterElo is the elo of who the function is currently be appplied to, not their opponent

      winnerEntity.elo![winnerEntity.elo!.length - 1]
      and
      loserEntity.elo![loserEntity.elo!.length - 1]
      both get the most recent elo rating that the fighter has had

    */

    /*
      adding extra elo gain and/or loss on wins/losses by KO/TKO,SUB,U-DEC,M-DEC, and S-DEC.  thoughts:

      frontend: you can toggle a button for any of these categories. upon toggle, a field pops up where you can enter in a number for the modifier (ex: 5, signifying 5 extra elo points on the category). 
      will probably need to cast param input to an int (or whatever the needed data type is) to idiot-proof)

      backend: we'll use submissions as an example.
      
      (fixed number, non percentage example)
      add int SUB_modifier_param as a param
      int SUB_modifier = SUB_modifier_param != null ? SUB_modifier_param : 0

      (percentage example)
      have the input be captured so that if a user enter '10' for 10 percent, SUB_modifier_param is set to 1.1

      add double SUB_modifier_param as a param
      double SUB_modifier = SUB_modifier_param != null ? SUB_modifier_param : 1.0
    */

   

  int calculateNewRating(double gameResult, double expectedScore, double kFactor, int fighterElo, FighterEntity fighter, List<double?> modifierList) {
      int newRating = fighterElo + (kFactor * (gameResult - expectedScore)).toInt();

      //if SUB_modifier_param != null, SUB_modifier = SUB_modifier_param.    else, SUB_modifier = 1.0
      // double SUB_modifier = SUB_modifier_param ?? 1.0;
      
      for (double? item in modifierList){
        
        // need to check if the item is null. if it is, we set it to 1.0
        if(item == null){
         
          newRating = newRating; // I think this is redundant
        }
        else{
           //               ↓ use fighter elo instead of newRating. because we want a % increase on the math that is occuring on their old rating. applying it to their new rating would give them a bigger buff that isn't accurate.
          newRating += (fighterElo * (item! / 100)).toInt(); // if item is null the app will crash.  // /100 is so that users can input "5" and have a modifier of 5 percent
        }
        
      }
      
      return newRating;
  }

  //fighterElo is the elo of who the function is currently be appplied to, not their opponent
  double getExpectedScore(int opponentRating, int fighterElo) { // is opponent rating the opponent's elo?
    return 1.0 / (1.0 + pow(10.0, ((opponentRating - fighterElo).toDouble() / 400.0)));
  }

  void setNewRating(String winner, String r_fighter, String b_fighter, Map<String,FighterEntity> fighterHashMap, List<double?> modifierList) {
        
    double kFactor = 20.0;
    double expectedScore = 0.0;
    int winnerNewRating = 0;
    int loserNewRating = 0;
    

    //if winner == "Red" set winnStr to the value of r_fighter. else, set winnStr to the value of b_fighter.
    String winnerStr = winner == "Red" ? r_fighter : b_fighter;
    //if winner == "Red" set loserStr to the value of b_fighter. else, set winnStr to the value of r_fighter.
    String loserStr = winner == "Red" ? b_fighter : r_fighter;
    FighterEntity winnerEntity = fighterHashMap[winnerStr]!;
    FighterEntity loserEntity = fighterHashMap[loserStr]!;

    //update winner's record
    winnerEntity.wins = (winnerEntity.wins ?? 0) + 1;  // Increment wins if winnerEntity is not null
    fighterHashMap[winnerStr] = winnerEntity;

    // update loser's record
    loserEntity.losses = (loserEntity.losses ?? 0) + 1;      
    fighterHashMap[loserStr] = loserEntity;

    //setting new rating for winner
    kFactor = (winnerEntity.elo![winnerEntity.elo!.length - 1] > 2500) ? 15.0 : 20.0;
    expectedScore = getExpectedScore(loserEntity.elo![loserEntity.elo!.length - 1],winnerEntity.elo![winnerEntity.elo!.length - 1]);

    winnerNewRating = calculateNewRating(1.0, expectedScore, kFactor, winnerEntity.elo![winnerEntity.elo!.length - 1], winnerEntity, modifierList);
    //winnerEntity.elo!.add(newRating); // this affects getExpectedScore when it's called for the loser

    //setting new rating for loser
    kFactor = (loserEntity.elo![loserEntity.elo!.length - 1] > 2500) ? 15.0 : 20.0;
    expectedScore = getExpectedScore(winnerEntity.elo![winnerEntity.elo!.length - 1],loserEntity.elo![loserEntity.elo!.length - 1]);
    
    loserNewRating = calculateNewRating(0.0, expectedScore, kFactor, loserEntity.elo![loserEntity.elo!.length - 1], loserEntity, modifierList);
    
    /*
    add these new ratings both at the end. if you were to add the winner's new rating before you got the expected score for the loser, then the expected
    score for the loser would be calculated of the winner's elo after the match, not at the time of the match. 
    This leads to the loser having less of a penalty for losing.
    */ 
    winnerEntity.elo!.add(winnerNewRating);
    loserEntity.elo!.add(loserNewRating);

    }

}