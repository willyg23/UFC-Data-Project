
import 'package:json_test/features/domain/entities/fighter.dart';
import 'package:json_test/features/domain/usecases/elo_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;

List<charts.Series<EloData, DateTime>> createChartData(Map<String, FighterEntity> fighters) {
  List<charts.Series<EloData, DateTime>> seriesList = [];
  Set<DateTime> usedDates = {}; 

  fighters.forEach((fighterName, fighterEntity) {
    charts.Series<EloData, DateTime> series = charts.Series(
      id: fighterName,
      domainFn: (EloData dataPoint, _) => dataPoint.date,
      measureFn: (EloData dataPoint, _) => dataPoint.elo,
      data: [], 
    );

    fighterEntity.fighterEloHashMap.forEach((key, elo) {
      // Parse date from the key (assuming 'fighterName-MM-DD-YYYY' format)
      List<String> dateParts = key.split('-').sublist(1);
      DateTime fightDate = DateTime(
        int.parse(dateParts[2]), // Year
        int.parse(dateParts[0]), // Month
        int.parse(dateParts[1])  // Day
      );

      // Check for duplicate dates
      if (!usedDates.contains(fightDate)) {
        series.data.add(EloData(fightDate, elo));
        usedDates.add(fightDate); 
      }
    });

    seriesList.add(series);
  });

  return seriesList;
}