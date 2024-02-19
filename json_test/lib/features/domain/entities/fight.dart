//import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:json_test/features/domain/entities/fighter.dart';

class FightEntity extends Equatable {

  int ? fight_id;
  String ? r_fighter_string;
  String ? b_fighter_string;
  String ? winner;
  int ? draw;
  String ? finish; // U-DEC , S-DEC , M-DEC , SUB , KO/TKO , idk what it is for DQ yet. 
  //Not sure about draw either. I looked up cowboy vs niko price but that shit just wasn't in the data set??? The card the fight was on is, (tyron vs colby) but the cowboy vs niko fight isn't there. weird.
  //for now I think I'll just not include those and then do it later.
  int ? r_odds;
  int ? b_odds;
  int ? r_age;
  int ? b_age;
  
  FighterEntity ? b_fighter_entity;
  FighterEntity ? r_fighter_entity;

  String ? weight_class;

  FightEntity({

    this.fight_id,
    this.r_fighter_string,
    this.b_fighter_string,
    this.winner,
    this.draw,
    this.finish,
    this.r_odds,
    this.b_odds,
    this.r_age,
    this.b_age,
    this.b_fighter_entity,
    this.r_fighter_entity,
    this.weight_class,

  });

  @override
  List < Object ? > get props {
    return [
      fight_id,
      b_fighter_string,
      r_fighter_string,
      winner,
      draw,
      finish,
      r_odds,
      b_odds,
      r_age,
      b_age,
      b_fighter_entity,
      r_fighter_entity,
      weight_class,
    ];
  }

}