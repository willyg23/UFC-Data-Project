import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:json_test/features/domain/entities/fight.dart';
import 'package:json_test/features/domain/entities/fighter.dart';
import 'package:json_test/features/domain/usecases/eloCalculations.dart';
import 'package:intl/intl.dart';
// import 'dart:async';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


/*
note:
before I had it as: final eloCalculator = eloCalculator();
but that doesn't work, because dart doesn't allow the object and the class name to be the same
*/
  final eloCalculatorObject = eloCalculator(); 
  
  Map<String, int> eloHashMap = {};
  // 'late' allows you to declare a vairable without immediately assinging it a value.
  // make sure not to attempt accessing the late variable before it's initialized, that'll throw a runtime error

  late Map<String,FighterEntity> _fighters = {};

  late List<FightEntity> _fights = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('lib/features/data/data_sources/ufc_data.json');

    // this variable is final since we never add, remove, or modify any of the fights within the JSON
    // The dynamic type in Dart is a special type that tells the Dart analyzer to allow any type of value to be assigned to this variable.
    // So 'List<dynamic>' means that the list data can contain elements of any type.
    final List<dynamic> _data = json.decode(response)['items']; // should you be doing final here?

    setState(() {
      
      for(int i = _data.length - 1; i >= 0; i--){ //start from the bottom, as that's chroniclogical order

        FightEntity _fightEntity = new FightEntity();

        //it is useful to have both the fighter entity and the fighter string, since the key to the _fighters hashmap is a string, the string version is needed.
        _fightEntity.r_fighter_string = _data[i]['R_fighter'];
        _fightEntity.b_fighter_string = _data[i]['B_fighter'];

        // if  _fightEntity.b_fighter is in the _fighters hashmap, add b_fighter's fighterEntity (accessed via the _fighters hashmap) to _fightEntity's b_fighter_entity value (_fightEntity.b_fighter_entity)
        if(_fighters[_fightEntity.b_fighter_string] != null){
          _fightEntity.b_fighter_entity = _fighters[_fightEntity.b_fighter_string];
        }
        // if  _fightEntity.r_fighter is in the _fighters hashmap, add r_fighter's fighterEntity (accessed via the _fighters hashmap) to _fightEntity's r_fighter_entity value (_fightEntity.r_fighter_entity)
        if(_fighters[_fightEntity.r_fighter_string] != null){
          _fightEntity.r_fighter_entity = _fighters[_fightEntity.r_fighter_string];
        }

        _fightEntity.winner = _data[i]['Winner'];
       

       // explanation for what's going on in code blocks like this can be found a little bit lower
        dynamic rOddsValue = _data[i]['R_odds'];
        _fightEntity.r_odds = rOddsValue != null && rOddsValue != ""
            ? rOddsValue is int
                ? rOddsValue
                : int.tryParse(rOddsValue.toString()) ?? -69420
            : -69420;
                
        
        dynamic bOddsValue = _data[i]['B_odds'];
        _fightEntity.b_odds = bOddsValue != null && bOddsValue != ""
            ? bOddsValue is int
                ? bOddsValue
                : int.tryParse(bOddsValue.toString()) ?? -69420
            : -69420;
        _fightEntity.weight_class = _data[i]['weight_class'];
        _fightEntity.finish = _data[i]['finish'];
        _fightEntity.r_age = _data[i]['R_age'];
        _fightEntity.b_age = _data[i]['B_age'];
        _fightEntity.fight_id = _data[i]['fight_id'];

        String dateToParse = _data[i]['date']; // Assuming format like "MM/DD/YYYY"

        // Customize the DateFormat if your input is different
        var dateFormat = DateFormat("MM/dd/yyyy"); 
        DateTime parsedDate = dateFormat.parse(dateToParse); 

        int year = parsedDate.year; 
        int month = parsedDate.month;
        int day = parsedDate.day;
        _fightEntity.year = year;
        _fightEntity.month = month;
        _fightEntity.day = day;

        _fights.add(_fightEntity);


        /*

          Explaining the absolute tomfoolery that is occuring with statements like these

          avg_SIG_STR_pct: _data[i]["B_avg_SIG_STR_pct"] != null && _data[i]["B_avg_SIG_STR_pct"] != ""
            ? _data[i]["B_avg_SIG_STR_pct"] is double
              ? _data[i]["B_avg_SIG_STR_pct"]
              : double.tryParse(_data[i]["B_avg_SIG_STR_pct"]) ?? -69420
            : -69420,

            Initially, I wanted to do things nice and simple, like this:  avg_SIG_STR_landed: _data[i]["R_avg_SIG_STR_landed"]
            But some values in the data set are numbers of String. So I used double.parse(). 
            But some values in the data set are just null, like in fight_id = 2, this is an actual piece of data: "B_avg_SIG_STR_pct": "",    You can't call double.parse on a null value without getting an error though.

            So, here's what that thick ass block of code above does:
            Checks if _data[i]["B_avg_SIG_STR_pct"] is not null and not an empty string.
            If it's not null and not an empty string, it checks if it's already a double type.
            If it's already a double type, it assigns its value directly to avg_SIG_STR_pct.
            If it's not a double type, it tries to parse it to a double. If parsing is successful, it assigns the parsed value to avg_SIG_STR_pct. If parsing fails (double.tryParse returns null), it assigns -69420 to avg_SIG_STR_pct.
            If _data[i]["B_avg_SIG_STR_pct"] is null or an empty string, it assigns -69420 to avg_SIG_STR_pct.



            Come to think of it I'll probably replace the -69420 with just "null". The thought process was (these are notes that I wrote earlier):
            boom so just check if each variable is null
            and if it is then just don't assign anything to the field? if you assign it a zero that could falsely impact the stats.
            what you could do is just every time there's a null variable you assign the entity field some ridiculous number like -69420. 
            Then, when making stats or whatever, if a number is -69420, you know not to include it in the stats calculation. 
            Since -69420 isn't the actual value, but rather a sign that there wasn't any value at all, and thus nothing to include into the stats.


            Like damn I really could just do all that but just with null lol. That was so overthought, you'd think I was really embracing the "-69420". (since it's a negative 69420, does that mean I'm waiting til marriage, and abstaining from usage of illegal narcotics? )

        */

        if(_fighters[_fightEntity.r_fighter_string] == null){

          _fighters[_fightEntity.r_fighter_string!] = FighterEntity(
            name: _fightEntity.r_fighter_string,
            weight_classes: [_fightEntity.weight_class!], //  weight_classes is a list containing just "_fightEntity.weight_class". Doesn't account for fighters who fight in multiple weight classes. 
            //weight_class_rank: [int.parse(_data[i]["R_match_weightclass_rank"])],  commented out until bug is fixed
            gender: _data[i]["gender"],
            current_win_streak: _data[i]["R_current_win_streak"],
            current_loss_streak: _data[i]["R_current_lose_streak"],
            avg_SIG_STR_landed: _data[i]["R_avg_SIG_STR_landed"] != null && _data[i]["R_avg_SIG_STR_landed"] != ""
            ? _data[i]["R_avg_SIG_STR_landed"] is double
              ? _data[i]["R_avg_SIG_STR_landed"]
              : double.tryParse(_data[i]["R_avg_SIG_STR_landed"].toString()) ?? -69420
            : -69420,
           avg_SIG_STR_pct: _data[i]["R_avg_SIG_STR_pct"] != null && _data[i]["R_avg_SIG_STR_pct"] != ""
            ? _data[i]["R_avg_SIG_STR_pct"] is double
              ? _data[i]["R_avg_SIG_STR_pct"]
              : double.tryParse(_data[i]["R_avg_SIG_STR_pct"].toString()) ?? -69420
            : -69420,
            avg_SUB_ATT: _data[i]["R_avg_SUB_ATT"] != null && _data[i]["R_avg_SUB_ATT"] != ""
            ? _data[i]["R_avg_SUB_ATT"] is double
              ? _data[i]["R_avg_SUB_ATT"]
              : double.tryParse(_data[i]["R_avg_SUB_ATT"].toString()) ?? -69420
            : -69420,
            avg_TD_landed: _data[i]["R_avg_TD_landed"] != null && _data[i]["R_avg_TD_landed"] != ""
            ? _data[i]["R_avg_TD_landed"] is double
              ? _data[i]["R_avg_TD_landed"]
              : double.tryParse(_data[i]["R_avg_TD_landed"].toString()) ?? -69420
            : -69420,
            avg_TD_pct: _data[i]["R_avg_TD_pct"] != null && _data[i]["R_avg_TD_pct"] != ""
            ? _data[i]["R_avg_TD_pct"] is double
              ? _data[i]["R_avg_TD_pct"]
              : double.tryParse(_data[i]["R_avg_TD_pct"].toString()) ?? -69420
            : -69420,
            total_rounds_fought: _data[i]["R_total_rounds_fought"],
            total_title_bouts: _data[i]["R_total_title_bouts"],
            wins_by_Decision_Majority: _data[i]["R_win_by_Decision_Majority"],
            wins_by_Decision_Split: _data[i]["R_win_by_Decision_Split"],
            wins_by_Decision_Unanimous: _data[i]["R_win_by_Decision_Unanimous"],
            wins_by_KO: _data[i]["R_win_by_KO/TKO"],
            wins_by_Submission: _data[i]["R_win_by_Submission"],
            wins_by_TKO_Doctor_Stoppage: _data[i]["R_win_by_TKO_Doctor_Stoppage"],
            height_cms: _data[i]["R_Height_cms"] != null && _data[i]["R_Height_cms"] != ""
            ? _data[i]["R_Height_cms"] is double
              ? _data[i]["R_Height_cms"]
              : double.tryParse(_data[i]["R_Reach_cms"].toString()) ?? -69420
            : -69420,
            reach_cms: _data[i]["R_Reach_cms"] != null && _data[i]["R_Reach_cms"] != ""
            ? _data[i]["R_Reach_cms"] is double
              ? _data[i]["R_Reach_cms"]
              : double.tryParse(_data[i]["R_Reach_cms"].toString()) ?? -69420
            : -69420,
            elo: [1200], // 1200 as a placeholder for now. Not sure how what to put here right now.
            fight_history: [_fightEntity], // I believe that if they aren't yet in the list, then this is their first ufc fight. This line returns a list of fightEntities, with the current fight entity (their firt UFC figh) being the 0th and only fight in the list.
            stance: _data[i]["R_Stance"],
            // we set both wins and losses to 0 because we're going to increment them in the elo calculator. We do 0 instead of null, since you can't increment null.
            wins: 0,
            age: _fightEntity.r_age,
            losses: 0,
            
            );

// make sure to add the fighterEntity to the fightEntity after creating the fighterEntity has been created! I was forgetting to do this for a while lol
            _fightEntity.r_fighter_entity = _fighters[_fightEntity.r_fighter_string];

        }


        if(_fighters[_fightEntity.b_fighter_string] == null){  
      //_side = "B"
         _fighters[_fightEntity.b_fighter_string!] = FighterEntity(
            name: _fightEntity.b_fighter_string,
            weight_classes: [_fightEntity.weight_class!], //  weight_classes is a list containing just "_fightEntity.weight_class". Doesn't account for fighters who fight in multiple weight classes. 
            //weight_class_rank: [int.parse(_data[i]["R_match_weightclass_rank"])],  commented out until bug is fixed
            gender: _data[i]["gender"],
            current_win_streak: _data[i]["B_current_win_streak"],
            current_loss_streak: _data[i]["B_current_lose_streak"],
            avg_SIG_STR_landed: _data[i]["B_avg_SIG_STR_landed"] != null && _data[i]["B_avg_SIG_STR_landed"] != ""
            ? _data[i]["B_avg_SIG_STR_landed"] is double
              ? _data[i]["B_avg_SIG_STR_landed"]
              : double.tryParse(_data[i]["B_avg_SIG_STR_landed"].toString()) ?? -69420
            : -69420,
            avg_SIG_STR_pct: _data[i]["B_avg_SIG_STR_pct"] != null && _data[i]["B_avg_SIG_STR_pct"] != ""
            ? _data[i]["B_avg_SIG_STR_pct"] is double
              ? _data[i]["B_avg_SIG_STR_pct"]
              : double.tryParse(_data[i]["B_avg_SIG_STR_pct"].toString()) ?? -69420
            : -69420,
            avg_SUB_ATT: _data[i]["B_avg_SUB_ATT"] != null && _data[i]["B_avg_SUB_ATT"] != ""
            ? _data[i]["B_avg_SUB_ATT"] is double
              ? _data[i]["B_avg_SUB_ATT"]
              : double.tryParse(_data[i]["B_avg_SUB_ATT"].toString()) ?? -69420
            : -69420,
            avg_TD_landed: _data[i]["B_avg_TD_landed"] != null && _data[i]["B_avg_TD_landed"] != ""
            ? _data[i]["B_avg_TD_landed"] is double
              ? _data[i]["B_avg_TD_landed"]
              : double.tryParse(_data[i]["B_avg_TD_landed"].toString()) ?? -69420
            : -69420,
            avg_TD_pct: _data[i]["B_avg_TD_pct"] != null && _data[i]["B_avg_TD_pct"] != ""
            ? _data[i]["B_avg_TD_pct"] is double
              ? _data[i]["B_avg_TD_pct"]
              : double.tryParse(_data[i]["B_avg_TD_pct"].toString()) ?? -69420
            : -69420,
            total_rounds_fought: _data[i]["B_total_rounds_fought"],
            total_title_bouts: _data[i]["B_total_title_bouts"],
            wins_by_Decision_Majority: _data[i]["B_win_by_Decision_Majority"],
            wins_by_Decision_Split: _data[i]["B_win_by_Decision_Split"],
            wins_by_Decision_Unanimous: _data[i]["B_win_by_Decision_Unanimous"],
            wins_by_KO: _data[i]["B_win_by_KO/TKO"],
            wins_by_Submission: _data[i]["B_win_by_Submission"],
            wins_by_TKO_Doctor_Stoppage: _data[i]["B_win_by_TKO_Doctor_Stoppage"],
            height_cms: _data[i]["B_Height_cms"] != null && _data[i]["B_Height_cms"] != ""
            ? _data[i]["B_Height_cms"] is double
              ? _data[i]["B_Height_cms"]
              : double.tryParse(_data[i]["B_Height_cms"].toString()) ?? -69420
            : -69420,
            reach_cms: _data[i]["B_Reach_cms"] != null && _data[i]["B_Reach_cms"] != ""
            ? _data[i]["B_Reach_cms"] is double
              ? _data[i]["B_Reach_cms"]
              : double.tryParse(_data[i]["B_Reach_cms"].toString()) ?? -69420
            : -69420,
            elo: [1200], // 1200 as a placeholder for now. Not sure how what to put here right now.
            fight_history: [_fightEntity], // I believe that if they aren't yet in the list, then this is their first ufc fight. This line returns a list of fightEntities, with the current fight entity (their firt UFC figh) being the 0th and only fight in the list.
            stance: _data[i]["B_Stance"],
            // we set both wins and losses to 0 because we're going to increment them in the elo calculator. We do 0 instead of null, since you can't increment null.
            wins: 0,
            age: _fightEntity.r_age,
            losses: 0,
            );

            // make sure to add the fighterEntity to the fightEntity after creating the fighterEntity has been created! I was forgetting to do this for a while lol
            _fightEntity.b_fighter_entity = _fighters[_fightEntity.b_fighter_string];
        }

      }

/*
some frontend goals:
have a toggle checkbox for each modifier
when the toggle is cilcked, have an input box appear for users to enter what percent they want the increase or decrease to be by.
have it be so +50% is 1.5, not .5, -50% is .5,
maybe have anothe box appear for the input to be positive or negative?
*/



      print('Creation of _fighters hasmap and _fights list has been completed! ');
      print('Length of the _fighters hashmap: ${_fighters.length}');
      print('Length of the _fights list: ${_fights.length}');

      //modifiers testing variables
      
/*
      I think that using doubles is doing something crazy with the math. If I put in 50.0 for either modifier, that should be a 50% increase in elo gain, per win via 
      the modifer that was chosen. Yet people's rankings end up in the billions. 
      Right now it's a 50% increase in all fighter's elos because my code is wrong. But even then, fighters elos going into the billions is not a 50% increase.
      I vaguely remember learning about how doubles can do weird stuff if you don't use them correctly. So I'm going to look into that. Maybe I just end up using ints?
      But if I'm going to do a modifier that's based on percentage, I'm pretty sure something will turn into a double at some point. I'll look into whether or not I
      have to use doubles here.
*/
      List<double?> _modifiers = [];
      double? sub_win_input = null; // precent that you want to modify by
      double? ko_tko_input = null;
      _modifiers.add(sub_win_input);
      _modifiers.add(ko_tko_input);
      String eloHashMapString = "";
      FighterEntity? currentFighter;

      for (FightEntity fight in _fights) {      
        // if(fight.b_fighter_string == null){ 
        //   print('b fighter that is null fight id: ${fight.fight_id}');
        // }

// we do this if statement because dart is expecting these values to be not null in setNewRating, and there will be a runtime error if a null value is passed in setNewRating.
        if(fight.winner != null && fight.r_fighter_string != null && fight.b_fighter_string != null){
          eloCalculatorObject.setNewRating(fight.winner!, fight.r_fighter_string!, fight.b_fighter_string!, _fighters, _modifiers);
          eloHashMapString = "${fight.r_fighter_string}-${fight.month}-${fight.day}-${fight.year}";
          currentFighter = _fighters[fight.r_fighter_string];
          eloHashMap[eloHashMapString] = currentFighter!.elo!.last; //creates an entry in the hashmap

          eloHashMapString = "${fight.b_fighter_string}-${fight.month}-${fight.day}-${fight.year}";
          currentFighter = _fighters[fight.b_fighter_string];
          eloHashMap[eloHashMapString] = currentFighter!.elo!.last; //creates an entry in the hashmap
        }
       // print('year: ${fight.year} month: ${fight.month} day: ${fight.day}');
      }


      // lets print the fighter with the highest ELO
      // .entries is all of the items in the map in a class "MapEntry" which has 2 properies "key" and "value"
    // hover over toList to see the type that it returns
    // ! == i know this isn't null, throw an error if it is
    // ? == I know this isn't null, set it to a default value if it is, typically zero
    // MapEntry == single entry in a hashMap. A hashmap is a collection of these where you can search by these.
    // toList is of type List<MapEntry<String, FighterEntity>>, sortedFighters needs to be the same to match.
    List<MapEntry<String, FighterEntity>> sortedFighters = _fighters.entries.toList()
      ..sort((a, b) => a.value.elo!.last.compareTo(b.value.elo!.last));


    int q = sortedFighters.length + 1;
    for (MapEntry mapEntry in sortedFighters) {
      q = q - 1;
      //mapEntry.key is the fighter's name  (key of the map entry)
      //mapEntry.value is the fighter entity (value of the map entry)
      print('Fighter: ${mapEntry.key} Elo: ${mapEntry.value.elo!.last}  Win/Loss ratio: W${mapEntry.value.wins} L${mapEntry.value.losses}  Rank: ${q}'); // any . function after shows up as grey in the IDE but still works just fine. worth noting just in case.
    // invoke deez nuts in production code dart
    }

    print("eloHashMap Test");
    print(eloHashMap["Jon Jones-7-6-2019"]);
    
      /*
        useful statements
        -----------------
        print all fight names in the _fighters hashmap
          print(_fighters.keys.toList());

        print every fighter entity (not as useful since this is a lot of freaking text that will be printed out)
          //  _fighters.forEach((key, value) {
          //     print('$key: $value');
          //   });
              

      */
    }); //set state end

  } // readJson end

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
     
      body: ElevatedButton(
        onPressed: () {
          readJson();
        },
        child: Center(child: Text("Load Json"))),

    );
  }
}