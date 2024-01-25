import 'dart:ffi';

import 'package:equatable/equatable.dart';

class FighterEntity extends Equatable {

  String ? name;
  String ? weight_class;
  int ? weight_class_rank;
  String ? gender;
  int ? current_win_streak;
  int ? current_loss_streak;
  Float ? avg_SIG_STR_landed;
  Float ? avg_SIG_STR_pct;
  Float ? avg_SUB_ATT;
  Float ? avg_TD_landed;
  Float ? avg_TD_pct;
  int ? total_rounds_fought;
  int ? total_title_bouts;
  int ? wins_by_Decision_Majority;
  int ? wins_by_Decision_Split;
  int ? wins_by_Decision_Unanimous;
  int ? wins_by_KO;
  int ? wins_by_Submission;
  int ? wins_by_TKO_Doctor_Stoppage;
  Float ? height_cms;
  Float ? reach_cms;
 
  
  
  String ? stance;

  FighterEntity({
    this.name,
    this.weight_class,
    this.weight_class_rank,
    this.gender,
    this.current_win_streak,
    this.current_loss_streak,
    this.avg_SIG_STR_landed,
    this.avg_SIG_STR_pct,
    this.avg_SUB_ATT,
    this.avg_TD_landed,
    this.avg_TD_pct,
    this.total_rounds_fought,
    this.total_title_bouts,
    this.wins_by_Decision_Majority,
    this.wins_by_Decision_Split,
    this.wins_by_Decision_Unanimous,
    this.wins_by_KO,
    this.wins_by_Submission,
    this.wins_by_TKO_Doctor_Stoppage,
    this.height_cms,
    this.reach_cms,

  });

  // String setr_fighter(String input){
  //   return input;
  // }


  @override
  List < Object ? > get props {
    return [
      name,
      weight_class,
      weight_class_rank,
      gender,
      current_win_streak,
      current_loss_streak,
      avg_SIG_STR_landed,
      avg_SIG_STR_pct,
      avg_SUB_ATT,
      avg_TD_landed,
      avg_TD_pct,
      total_title_bouts,
      wins_by_Decision_Majority,
      wins_by_Decision_Split,
      wins_by_Decision_Unanimous,
      wins_by_KO,
      wins_by_Submission,
      wins_by_TKO_Doctor_Stoppage,
      height_cms,
      reach_cms,
    ];
  }

}