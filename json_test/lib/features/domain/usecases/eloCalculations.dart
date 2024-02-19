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
  int calculateNewRating(double gameResult, double expectedScore, double kFactor, int fighterElo, FighterEntity fighter) {
      int newRating = fighterElo + (kFactor * (gameResult - expectedScore)).toInt();
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

    winnerNewRating = calculateNewRating(1.0, expectedScore, kFactor, winnerEntity.elo![winnerEntity.elo!.length - 1], winnerEntity);
    //winnerEntity.elo!.add(newRating); // this affects getExpectedScore when it's called for the loser

    //setting new rating for loser
    kFactor = (loserEntity.elo![loserEntity.elo!.length - 1] > 2500) ? 15.0 : 20.0;
    expectedScore = getExpectedScore(winnerEntity.elo![winnerEntity.elo!.length - 1],loserEntity.elo![loserEntity.elo!.length - 1]);
    
    loserNewRating = calculateNewRating(0.0, expectedScore, kFactor, loserEntity.elo![loserEntity.elo!.length - 1], loserEntity);
    
    /*
    add these new ratings both at the end. if you were to add the winner's new rating before you got the expected score for the loser, then the expected
    score for the loser would be calculated of the winner's elo after the match, not at the time of the match. 
    This leads to the loser having less of a penalty for losing.
    */ 
    winnerEntity.elo!.add(winnerNewRating);
    loserEntity.elo!.add(loserNewRating);

    }

}