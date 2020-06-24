import 'package:flutter/foundation.dart';
import './scheduleItem.dart';

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