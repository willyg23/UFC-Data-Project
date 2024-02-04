//import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:json_test/features/domain/entities/fight.dart';
import 'package:json_test/features/domain/entities/fight.dart';
import 'package:json_test/features/domain/entities/fighter.dart';

class eloCalculator{

  int setNewRating(String winner, String r_fighter, String b_fighter, Map<String,FighterEntity> fighterHashMap) {
        

    if(winner == "Red"){
      FighterEntity winnerEntity = fighterHashMap[r_fighter]!;
      FighterEntity loserEntity = fighterHashMap[b_fighter]!;
       // Increment wins if winnerEntity is not null
      winnerEntity.wins = (winnerEntity.wins ?? 0) + 1;
      // Update the fighterHashMap with the modified entity
      fighterHashMap[r_fighter] = winnerEntity;
      loserEntity.wins = (loserEntity.wins ?? 0) + 1;
      // Update the fighterHashMap with the modified entity
      fighterHashMap[b_fighter] = loserEntity;
    }

    else if(winner == "Blue"){
      FighterEntity winnerEntity = fighterHashMap[b_fighter]!;
      FighterEntity loserEntity = fighterHashMap[r_fighter]!;
       // Increment wins if winnerEntity is not null
      winnerEntity.wins = (winnerEntity.wins ?? 0) + 1;
      // Update the fighterHashMap with the modified entity
      fighterHashMap[b_fighter] = winnerEntity;
      // Update the fighterHashMap with the modified entity
      fighterHashMap[r_fighter] = loserEntity;
      loserEntity.wins = (loserEntity.wins ?? 0) + 1;
      // Update the fighterHashMap with the modified entity
      fighterHashMap[b_fighter] = loserEntity;

    }
    //TODO: conditionals for draws, DQs,  no contests. DQs and no contests might be the same thing, need to look into that.

      // increment winner's wins
      
      // increment loser's losses

        double kFactor = (elo > 2500) ? 15.0 : 20.0;
        double expectedScore = getExpectedScore(opponentRating);

        return calculateNewRating(gameResult, expectedScore, kFactor);
    }

}