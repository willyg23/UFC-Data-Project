import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:json_test/features/domain/entities/fight.dart';
import 'package:json_test/features/domain/entities/fighter.dart';



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

  List _items = [];
  FightEntity _fightEntity = new FightEntity();

  // 'late' allows you to declare a vairable without immediately assinging it a value.
  // make sure not to attempt accessing the late variable before it's initialized, that'll throw a runtime error

  // late List<FightEntity> _fights; // was throwing LateInitializationError 
  late Map<String,FighterEntity> _fighters = {}; // do I need to / should I add final to this?

  // do I need to / should I add final to this?
  late List<FightEntity> _fights = [];

  


  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/sample.json');

    //remove the 'final' from here? It depends how I plan to add fights. If I'm just going to release an update with an updated json file, then probably not.
    //changing or adding onto the amount of fights in the json via a function in the code seems way ovvercomplicated to just simply updating the JSON.
    // The dynamic type in Dart is a special type that tells the Dart analyzer to allow any type of value to be assigned to this variable.
    // So 'List<dynamic>' means that the list data can contain elements of any type.
    final List<dynamic> _data = json.decode(response)['items']; 
    Random random = Random();

    // print("  _items.length: ${_items.length}");
    // print("  data.length: ${data.length}");
    // print("  R_Fighter: ${_items[1]['id']}");

    //print("  first item in data: ${data.first}");
    //print("  first item in data: ${data[0]['id']}"); // returns 'p1' when using test json, which is a success 

    //print("  first item in data: ${_data[0]['R_fighter']}"); // it workssss baby lets go alhamdulilah
    // print("  _first item in _items: ${_items.firstOrNull}"); // returns null

    // setState(){

    // }

    setState(() {
      
      for(int i = _data.length - 1; i >= 0; i--){ //start from the bottom, as that's chroniclogical order

      /*TODO: need to add more than what you have now on what happens if the _fightEntity.b_fighter_string or r is in the hashmap.
      one example being, if the fighter isn't new to the hashmap, you add the fightEntity to his fight_history field.
      */

        //print("  R_Fighter: ${_data[i]['R_fighter']}");
          
            //won't keep both of these forever, as it's redundant. Just keeping it like that for now because I'm just implementing the fighter entity stuff.
            //so I'll keep both in case i need to use one or the other. 
            // actually it might be useful to have both, since the key to the _fighters hashmap is a string, the string version is needed
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
        // _fightEntity.r_odds = _data[i]['R_odds'];
        dynamic rOddsValue = _data[i]['R_odds'];
        _fightEntity.r_odds = rOddsValue != null && rOddsValue != ""
            ? rOddsValue is int
                ? rOddsValue
                : int.tryParse(rOddsValue.toString()) ?? -69420
            : -69420;
                
        //_fightEntity.b_odds = _data[i]['B_odds'];
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

        // trying to figure out why both B and R_match_weightclass_rank has no value
        // print('Value of weight class rank: ${_data[i]["B_match_weightclass_rank"]}'); // is an int, has no value for some reason. was trying to parse it to an int, but you can't parse nothing into an int, without gettinga  FormatException.
        // print('Value of B_sig_strike_landed: ${_data[i]["B_avg_SIG_STR_landed"]}'); //is a Float, prints fine, has a value
        // print('Value of B_age: ${_data[i]["B_age"]}'); // is an int, prints fine, ahs a value



        _fights.add(_fightEntity);


        /*

          Explaining the absolute tomfoolery that is occuring with statements like these

          avg_SIG_STR_pct: _data[i]["B_avg_SIG_STR_pct"] != null && _data[i]["B_avg_SIG_STR_pct"] != ""
            ? _data[i]["B_avg_SIG_STR_pct"] is double
              ? _data[i]["B_avg_SIG_STR_pct"]
              : double.tryParse(_data[i]["B_avg_SIG_STR_pct"]) ?? -69420
            : -69420,

            Initially, I wanted to do things nice and simple, like this: // avg_SIG_STR_landed: _data[i]["R_avg_SIG_STR_landed"]
            But some values in the data set are numbers of String. So I used double.parse(). 
            But some values in the data set are just null, like in fight_id = 2, this is an actual piece of data: "B_avg_SIG_STR_pct": "",    You can't call double.parse on a null value without getting an error though.

            So, here's what that block of code does:
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

            // print("Data Type: ${_data[i]["R_avg_SIG_STR_landed"].runtimeType}");
            // print("Value: ${_data[i]["R_avg_SIG_STR_landed"]}");
            // print("value of _data.length: ${_data.length}");
            // print("value of i: ${i}");
            // print("Rfighter name: ${_data[i]["R_Fighter"]}");
            // print("iteration # fight_id: ${_data[i]["fight_id"]}");


          // because FightEntity's 'r_fighter_string' is nullable, and the hasmap's key is not nullable, we need to tell dart the value _fightEntity.r_fighter_string! isn't null
          // otherwise there's a type mismatch, as String != String ?
          //_fighters[_fightEntity.r_fighter_string!] = new FighterEntity(); 
          _fighters[_fightEntity.r_fighter_string!] = FighterEntity(
            name: _fightEntity.r_fighter_string,
            weight_classes: [_fightEntity.weight_class!], //  weight_classes is a list containing just "_fightEntity.weight_class". Doesn't account for fighters who fight in multiple weight classes. 
            //weight_class_rank: [int.parse(_data[i]["R_match_weightclass_rank"])],  commented out until bug is fixed
            gender: _data[i]["gender"],
            current_win_streak: _data[i]["R_current_win_streak"],
            current_loss_streak: _data[i]["R_current_lose_streak"],
            // avg_SIG_STR_landed: _data[i]["R_avg_SIG_STR_landed"],
            avg_SIG_STR_landed: _data[i]["R_avg_SIG_STR_landed"] != null && _data[i]["R_avg_SIG_STR_landed"] != ""
            ? _data[i]["R_avg_SIG_STR_landed"] is double
              ? _data[i]["R_avg_SIG_STR_landed"]
              : double.tryParse(_data[i]["R_avg_SIG_STR_landed"].toString()) ?? -69420
            : -69420,
           //avg_SIG_STR_pct: _data[i]["R_avg_SIG_STR_pct"],
           avg_SIG_STR_pct: _data[i]["R_avg_SIG_STR_pct"] != null && _data[i]["R_avg_SIG_STR_pct"] != ""
            ? _data[i]["R_avg_SIG_STR_pct"] is double
              ? _data[i]["R_avg_SIG_STR_pct"]
              : double.tryParse(_data[i]["R_avg_SIG_STR_pct"].toString()) ?? -69420
            : -69420,
            //avg_SUB_ATT: _data[i]["R_avg_SUB_ATT"], // commented out until bug fixed, this shit is so goofy lol
            avg_SUB_ATT: _data[i]["R_avg_SUB_ATT"] != null && _data[i]["R_avg_SUB_ATT"] != ""
            ? _data[i]["R_avg_SUB_ATT"] is double
              ? _data[i]["R_avg_SUB_ATT"]
              : double.tryParse(_data[i]["R_avg_SUB_ATT"].toString()) ?? -69420
            : -69420,
            // avg_TD_landed: _data[i]["R_avg_TD_landed"],
            avg_TD_landed: _data[i]["R_avg_TD_landed"] != null && _data[i]["R_avg_TD_landed"] != ""
            ? _data[i]["R_avg_TD_landed"] is double
              ? _data[i]["R_avg_TD_landed"]
              : double.tryParse(_data[i]["R_avg_TD_landed"].toString()) ?? -69420
            : -69420,
            // avg_TD_pct: _data[i]["R_avg_TD_pct"],
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
            // height_cms: _data[i]["R_Height_cms"],
            height_cms: _data[i]["R_Height_cms"] != null && _data[i]["R_Height_cms"] != ""
            ? _data[i]["R_Height_cms"] is double
              ? _data[i]["R_Height_cms"]
              : double.tryParse(_data[i]["R_Reach_cms"].toString()) ?? -69420
            : -69420,
            // reach_cms: _data[i]["R_Reach_cms"],
            reach_cms: _data[i]["R_Reach_cms"] != null && _data[i]["R_Reach_cms"] != ""
            ? _data[i]["R_Reach_cms"] is double
              ? _data[i]["R_Reach_cms"]
              : double.tryParse(_data[i]["R_Reach_cms"].toString()) ?? -69420
            : -69420,
            elo: [1200], // 1200 as a placeholder for now. Not sure how what to put here right now.
            fight_history: [_fightEntity], // I believe that if they aren't yet in the list, then this is their first ufc fight. This line returns a list of fightEntities, with the current fight entity (their firt UFC figh) being the 0th and only fight in the list.
            stance: _data[i]["R_Stance"],
            wins: _data[i]["R_wins"],
            age: _fightEntity.r_age,
            );

        }


        if(_fighters[_fightEntity.b_fighter_string] == null){
          // because FightEntity's 'r_fighter_string' is nullable, and the hasmap's key is not nullable, we need to tell dart the value _fightEntity.r_fighter_string! isn't null
          // otherwise there's a type mismatch, as String != String ?
          //_fighters[_fightEntity.r_fighter_string!] = new FighterEntity(); 


            // print("Data Type: ${_data[i]["B_avg_TD_landed"].runtimeType}");
            // print("Value: ${_data[i]["B_avg_TD_landed"]}");
            // print("value of _data.length: ${_data.length}");
            // print("value of i: ${i}");
            // print("Bfighter name: ${_data[i]["B_Fighter"]}");
            // print("iteration # fight_id: ${_data[i]["fight_id"]}");

       
            // double avg_SIG_STR_pct;
            // if (_data[i]["B_avg_SIG_STR_pct"] is double) {
            //   avg_SIG_STR_pct = _data[i]["B_avg_SIG_STR_pct"];
            //   print("shit is a double apparently");
            // } else if (_data[i]["B_avg_SIG_STR_pct"] is String) {
            //   avg_SIG_STR_pct = double.parse(_data[i]["B_avg_SIG_STR_pct"]);
            //   print("shit is a string apparently");
            // } else {
            //   // Handle other types or null values if necessary
            //   // For example, set avg_SIG_STR_pct to a default value
            //   // avg_SIG_STR_pct = 0.0;
            //   print("else occured on SIG_STR_pct. SIG_STR_pct data type:");
            // }




         _fighters[_fightEntity.r_fighter_string!] = FighterEntity(
            name: _fightEntity.r_fighter_string,
            weight_classes: [_fightEntity.weight_class!], //  weight_classes is a list containing just "_fightEntity.weight_class". Doesn't account for fighters who fight in multiple weight classes. 
            //weight_class_rank: [int.parse(_data[i]["R_match_weightclass_rank"])],  commented out until bug is fixed
            gender: _data[i]["gender"],
            current_win_streak: _data[i]["B_current_win_streak"],
            current_loss_streak: _data[i]["B_current_lose_streak"],
            //avg_SIG_STR_landed: _data[i]["B_avg_SIG_STR_landed"], //brev how did this one not make an error first before avg_SUB_ATT? anyways I'm tapping out for tonight but look into this more later, ideally tommorrow.
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
            // avg_SUB_ATT: _data[i]["B_avg_SUB_ATT"], // commented out until bug fixed, this shit is so goofy lol
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
            // height_cms: _data[i]["B_Height_cms"],
            height_cms: _data[i]["B_Height_cms"] != null && _data[i]["B_Height_cms"] != ""
            ? _data[i]["B_Height_cms"] is double
              ? _data[i]["B_Height_cms"]
              : double.tryParse(_data[i]["B_Height_cms"].toString()) ?? -69420
            : -69420,
            //reach_cms: _data[i]["B_Reach_cms"],
            reach_cms: _data[i]["B_Reach_cms"] != null && _data[i]["B_Reach_cms"] != ""
            ? _data[i]["B_Reach_cms"] is double
              ? _data[i]["B_Reach_cms"]
              : double.tryParse(_data[i]["B_Reach_cms"].toString()) ?? -69420
            : -69420,
            elo: [1200], // 1200 as a placeholder for now. Not sure how what to put here right now.
            fight_history: [_fightEntity], // I believe that if they aren't yet in the list, then this is their first ufc fight. This line returns a list of fightEntities, with the current fight entity (their firt UFC figh) being the 0th and only fight in the list.
            stance: _data[i]["B_Stance"],
            wins: _data[i]["B_wins"],
            age: _fightEntity.r_age,
            );
        }

      }

// these next 2 return null?
      // print("${_data[0]['R_Fighter']}");
      // print("${_data[572]['R_Fighter']}");

      //print("${_items[0]['id']}");
      // print("${_items[468]['R_fighter']}");
      // print("${_items[468]['fight_id']}");

      print('Creation of _fighters hasmap and _fights list has been completed! ');
      print('Length of the _fighters hashmap: ${_fighters.length}');
      print('Length of the _fights list: ${_fights.length}');

      for (FightEntity fight in _fights) {
          print(fight.toString());
      }

      //  _fighters.forEach((key, value) {
      //     print('$key: $value');
      //   });

      // print('Random Fighter from _fighters hashamp: ${ _fighters[_fights[10].r_fighter_string]} \n');
      // print('Random fight details:');
      // print('Fight_ id: ${_fights[10].fight_id}\n R fighter: ${_fights[10].r_fighter_string}\n B fighter: ${_fights[10].b_fighter_string}\n Winner: ${_fights[10].winner}\n');

      // int randomNumber = random.nextInt(1001); 

      // for(int j = 0; j < 10; j++){

      //   randomNumber = random.nextInt(1001); 
      //   print('Random Fighter from _fighters hashamp: ${ _fighters[_fights[randomNumber].r_fighter_string]} \n');
      //   print('Random fight details:');
      //   print('Fight_ id: ${_fights[randomNumber].fight_id}\n R fighter: ${_fights[randomNumber].r_fighter_string}\n B fighter: ${_fights[randomNumber].b_fighter_string}\n Winner: ${_fights[randomNumber].winner}\n');
      // }





    });

    // setState(() {
    //   _items = data;
    //   print("Number of items: ${_items.length}");

      // // Print information about each item
      //   for (int i = 0; i < _items.length; i++) {
      //   print("Item ${i + 1}:");
      //   print("  ID: ${_items[i]['id']}");
      //   print("  Name: ${_items[i]['name']}");
      //   print("  Description: ${_items[i]['description']}");
      // }



// // ---TODO---: add a feature in here where you assign the entity's 'draw' value based on something in the data set.
//       for (int i = 0; i < 3; i++) {
      
//         if(sectionCounter == 0){
          
//           testFight1.r_fighter = _items[i]['R_fighter'];
//           testFight1.b_fighter = _items[i]['B_fighter'];
//           testFight1.winner = _items[i]['Winner'];
//           testFight1.r_odds = _items[i]['R_odds'];
//           testFight1.b_odds = _items[i]['B_odds'];

          
//         }
//         else if(sectionCounter == 1){

//         }
//         else if(sectionCounter == 2){
//           testFight1.finish = _items[i]['finish'];
//           testFight1.r_age = _items[i]['R_age'];
//           testFight1.b_age = _items[i]['B_age'];
//         }


//         if(sectionCounter < 2){
//           sectionCounter++;
//         }
//         else{
//           sectionCounter = 0;
//         }
      


//         /*

//         each fight is split into three sections / items in the json file. Different attributes of the fight are in different sections.
//         The purpose of section counter is to keep track of what section you're in. If you tried to access 'finish' from the json whilst i == 0, I believe that wouldn't work, since 'finish' would be in the 3rd item of the json file

//           first section of a fight in json file: (numbers represent items in the json file. Here the first sections of the first 3 fights are 0,3, and 6, respectively. )
//           |0| 1 2 -new fight- |3| 4 5 - new fight - |6| 7 8
          

//           second section of a fight in json file:
//           0 |1| 2 -new fight- 3 |4| 5 - new fight - 6 |7| 8 -new fight- 9 |10| 11 -new fight- 12 |13| 14 -new fight- 15 |16| 17 -new fight- 18 |19| 20
          

//           third section of a fight in json file:
//           0 1 |2| -new fight- 3 4 |5| - new fight - 6 7 |8| -new fight- 9 10 |11|


           

//         */
        
//       }
//       //print("  R_Fighter: ${_items[i]['R_fighter']}");
//       // print("  B_Fighter: ${_items[i]['B_fighter']}")
//       //print("setr_fighter test: ");
//       print(testFight1.r_fighter);
//       //print("setb_fighter test: ");
//       print(testFight1.b_fighter);
//       //print("rest of stuff:");
//       print(testFight1.winner);
//       print(testFight1.draw);
//       print(testFight1.finish);
//       print(testFight1.r_odds);
//       print(testFight1.b_odds);
//       print(testFight1.r_age);
//       print(testFight1.b_age);
//     });

  }

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
