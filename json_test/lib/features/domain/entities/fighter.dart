//import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:json_test/features/domain/entities/fight.dart';

class FighterEntity extends Equatable {

  String ? name;
  List<String> ? weight_classes;
  List <int> ? weight_class_rank;
  String ? gender;
  int ? current_win_streak;
  int ? current_loss_streak;
  double ? avg_SIG_STR_landed;
  double ? avg_SIG_STR_pct;
  double ? avg_SUB_ATT;
  double ? avg_TD_landed;
  double ? avg_TD_pct;
  int ? total_rounds_fought;
  int ? total_title_bouts;
  int ? wins_by_Decision_Majority;
  int ? wins_by_Decision_Split;
  int ? wins_by_Decision_Unanimous;
  int ? wins_by_KO;
  int ? wins_by_Submission;
  int ? wins_by_TKO_Doctor_Stoppage;
  double ? height_cms;
  double ? reach_cms;
 

 //idea. make a list that has elo and time (of the bout) correlated, so that way it's super easy to to make the graph. you could do this within one data structure. or have two lists that are correlated with each other
  List<int> ? elo; // this is a list so that we can display a fighter's elo over time, not just their current elo

  List<FightEntity> ? fight_history;
 
  String ? stance;

  int ? wins;

  int ? age;

  int ? losses;

  FighterEntity({
    this.name,
    this.weight_classes,
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
    this.elo,
    this.fight_history,
    this.stance,
    this.wins,
    this.age,
    this.losses,

  });

  @override
  List < Object ? > get props {
    return [
      name,
      weight_classes,
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
      elo,
      fight_history,
      stance,
      wins,
      age,
      losses,
    ];
  }

}