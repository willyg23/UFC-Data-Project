//import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:json_test/features/domain/entities/fight.dart';
import 'package:json_test/features/domain/entities/fight.dart';
import 'package:json_test/features/domain/entities/fighter.dart';
import 'dart:math';

class eloCalculator{


    /*
      gameResult == 1.0  // win
      gameResult == 5.0  // draw
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
    int newRating = 0;

    if(winner == "Red"){
      FighterEntity winnerEntity = fighterHashMap[r_fighter]!; // the exclamation point tells dart that this value is not going to be null.
      FighterEntity loserEntity = fighterHashMap[b_fighter]!;
      
      //update winner's record
      winnerEntity.wins = (winnerEntity.wins ?? 0) + 1;  // Increment wins if winnerEntity is not null
      fighterHashMap[r_fighter] = winnerEntity;

// update loser's record
      loserEntity.losses = (loserEntity.losses ?? 0) + 1;      
      fighterHashMap[b_fighter] = loserEntity;


//setting new rating for winner, which is red
      kFactor = (winnerEntity.elo![winnerEntity.elo!.length - 1] > 2500) ? 15.0 : 20.0;
      expectedScore = getExpectedScore(loserEntity.elo![loserEntity.elo!.length - 1],winnerEntity.elo![winnerEntity.elo!.length - 1]);

      newRating = calculateNewRating(1.0, expectedScore, kFactor, winnerEntity.elo![winnerEntity.elo!.length - 1], winnerEntity);
      winnerEntity.elo!.add(newRating); 

//setting new rating for loser, which is blue
      kFactor = (loserEntity.elo![loserEntity.elo!.length - 1] > 2500) ? 15.0 : 20.0;
      expectedScore = getExpectedScore(winnerEntity.elo![winnerEntity.elo!.length - 1],loserEntity.elo![loserEntity.elo!.length - 1]);

      newRating = calculateNewRating(1.0, expectedScore, kFactor, loserEntity.elo![loserEntity.elo!.length - 1], loserEntity);
      loserEntity.elo!.add(newRating); 
   

    }

    else if(winner == "Blue"){
      FighterEntity winnerEntity = fighterHashMap[b_fighter]!;
      FighterEntity loserEntity = fighterHashMap[r_fighter]!;
      
      // update winner's record
      winnerEntity.wins = (winnerEntity.wins ?? 0) + 1;
      // Update the fighterHashMap with the modified entity
      fighterHashMap[b_fighter] = winnerEntity;

      // update loser's record
      loserEntity.losses = (loserEntity.losses ?? 0) + 1;
      // Update the fighterHashMap with the modified entity
      fighterHashMap[b_fighter] = loserEntity;


//setting new rating for winner, which is blue
      kFactor = (winnerEntity.elo![winnerEntity.elo!.length - 1] > 2500) ? 15.0 : 20.0;
      expectedScore = getExpectedScore(loserEntity.elo![loserEntity.elo!.length - 1],winnerEntity.elo![winnerEntity.elo!.length - 1]);

      newRating = calculateNewRating(1.0, expectedScore, kFactor, winnerEntity.elo![winnerEntity.elo!.length - 1], winnerEntity);
      winnerEntity.elo!.add(newRating); 

//setting new rating for loser, which is red
      kFactor = (loserEntity.elo![loserEntity.elo!.length - 1] > 2500) ? 15.0 : 20.0;
      expectedScore = getExpectedScore(winnerEntity.elo![winnerEntity.elo!.length - 1],loserEntity.elo![loserEntity.elo!.length - 1]);

      newRating = calculateNewRating(1.0, expectedScore, kFactor, loserEntity.elo![loserEntity.elo!.length - 1], loserEntity);
      loserEntity.elo!.add(newRating); 
   
    }
    //TODO: conditionals for draws, DQs,  no contests. DQs and no contests might be the same thing, need to look into that.

     
    
  

  

    }

}