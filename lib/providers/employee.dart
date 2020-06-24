import 'package:flutter/foundation.dart';

class Employee with ChangeNotifier {
  final String id;
  final String name;
  List<EmployeeSchedule> schedule = [];

  Employee({
    @required this.id,
    @required this.name,
    @required this.schedule,
  });
}

class EmployeeSchedule {
  final String id;
  final String date;
  final String from;
  final String till;

  EmployeeSchedule({
    @required this.id,
    @required this.date,
    @required this.from,
    @required this.till,
  });

}
