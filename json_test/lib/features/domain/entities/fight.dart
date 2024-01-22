import 'dart:ffi';

import 'package:equatable/equatable.dart';

class FightEntity extends Equatable {

  int ? fight_id;
  String ? r_fighter;
  String ? b_fighter;
  String ? winner;
  int ? draw;
  String ? finish; // U-DEC , S-DEC , M-DEC , SUB , KO/TKO , idk what it is for DQ yet. 
  //Not sure about draw either. I looked up cowboy vs niko price but that shit just wasn't in the data set??? The card the fight was on is, (tyron vs colby) but the cowboy vs niko fight isn't there. weird.
  //for now I think I'll just not include those and then do it later.
  int ? r_odds;
  int ? b_odds;
  int ? r_age;
  int ? b_age;

  FightEntity({
    this.fight_id,
    this.r_fighter,
    this.b_fighter,
    this.winner,
    this.draw,
    this.finish,
    this.r_odds,
    this.b_odds,
    this.r_age,
    this.b_age,

  });

  // String setr_fighter(String input){
  //   return input;
  // }


  @override
  List < Object ? > get props {
    return [
      fight_id,
      r_fighter,
      b_fighter,
      winner,
      draw,
      finish,
      r_odds,
      b_odds,
      r_age,
      b_age,
    ];
  }

}