import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:json_test/features/domain/entities/fight.dart';



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
  FightEntity testFight1 = new FightEntity();


  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/sample.json');
    final List<dynamic> data = json.decode(response)['items'];
    int sectionCounter = 0;

    setState(() {
      _items = data;
      print("Number of items: ${_items.length}");

      // // Print information about each item
      //   for (int i = 0; i < _items.length; i++) {
      //   print("Item ${i + 1}:");
      //   print("  ID: ${_items[i]['id']}");
      //   print("  Name: ${_items[i]['name']}");
      //   print("  Description: ${_items[i]['description']}");
      // }

//TODO: add a feature in here where you assign the entity's 'draw' value based on something in the data set.
      for (int i = 0; i < 3; i++) {
      
        if(sectionCounter == 0){
          
          testFight1.r_fighter = _items[i]['R_fighter'];
          testFight1.b_fighter = _items[i]['B_fighter'];
          testFight1.winner = _items[i]['Winner'];
          testFight1.r_odds = _items[i]['R_odds'];
          testFight1.b_odds = _items[i]['B_odds'];

          
        }
        else if(sectionCounter == 1){

        }
        else if(sectionCounter == 2){
          testFight1.finish = _items[i]['finish'];
          testFight1.r_age = _items[i]['R_age'];
          testFight1.b_age = _items[i]['B_age'];
        }


        if(sectionCounter < 2){
          sectionCounter++;
        }
        else{
          sectionCounter = 0;
        }
        /*

        each fight is split into three sections / items in the json file. Different attributes of the fight are in different sections.
        The purpose of section counter is to keep track of what section you're in. If you tried to access 'finish' from the json whilst i == 0, I believe that wouldn't work, since 'finish' would be in the 3rd item of the json file

          first section of a fight in json file: (numbers represent items in the json file. Here the first sections of the first 3 fights are 0,3, and 6, respectively. )
          |0| 1 2 -new fight- |3| 4 5 - new fight - |6| 7 8
          

          second section of a fight in json file:
          0 |1| 2 -new fight- 3 |4| 5 - new fight - 6 |7| 8 -new fight- 9 |10| 11 -new fight- 12 |13| 14 -new fight- 15 |16| 17 -new fight- 18 |19| 20
          

          third section of a fight in json file:
          0 1 |2| -new fight- 3 4 |5| - new fight - 6 7 |8| -new fight- 9 10 |11|


           

        */
        
      }
      //print("  R_Fighter: ${_items[i]['R_fighter']}");
      // print("  B_Fighter: ${_items[i]['B_fighter']}")
      //print("setr_fighter test: ");
      print(testFight1.r_fighter);
      //print("setb_fighter test: ");
      print(testFight1.b_fighter);
      //print("rest of stuff:");
      print(testFight1.winner);
      print(testFight1.draw);
      print(testFight1.finish);
      print(testFight1.r_odds);
      print(testFight1.b_odds);
      print(testFight1.r_age);
      print(testFight1.b_age);
    });
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
