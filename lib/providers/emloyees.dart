import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'employee.dart';

class Employees with ChangeNotifier {
  List<Employee> _items = [];

  List<Employee> get items {
    return [..._items];
  }

  Future<void> addemployee(
    Employee employee,
    List<EmployeeSchedule> employeeSchedule,
  ) async {
    final url = 'https://shift-it-ab63b.firebaseio.com/employees.json';
    try {
      await http.post(
        url,
        body: json.encode({
          'name': employee.name,
          'id': employee.id,
          'schedule': employeeSchedule
              .map((es) => {
                    'id': es.id,
                    'date': es.date,
                    'from': es.from,
                    'till': es.till,
                  })
              .toList(),
        }),
      );
      Employee(
        id: employee.id,
        name: employee.name,
        schedule: employeeSchedule,
      );
      // _items.add(_addEmployee);
      print(_items.toString);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addEmployeeSchedule(List<EmployeeSchedule> employeeSchedule,
      String employeeName, String employeeId) async {
    final url = 'https://shift-it-ab63b.firebaseio.com/employees/$employeeId.json';
    try {
      await http.patch(
        url,
        body: json.encode({
          'schedule': employeeSchedule
              .map((es) => {
                    'id': es.id,
                    'date': es.date,
                    'from': es.from,
                    'till': es.till,
                  })
              .toList(),
        }),
      );
      _items.insert(
        0,
        Employee(
          id: employeeId,
          name: employeeName,
          schedule: employeeSchedule,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetEmployee() async {
    var url = 'https://shift-it-ab63b.firebaseio.com/employees.json';
    // try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<Employee> loadedEmployees = [];
      extractedData.forEach((employeeId, employeeData) {
        loadedEmployees.add(Employee(
          id: employeeId,
          name: employeeData['name'],
          schedule: employeeData == null
              ? employeeData['schedule']
              : (employeeData['schedule'] as List<dynamic>)
                  .map(
                    (item) => EmployeeSchedule(
                      id: item['id'],
                      date: item['date'],
                      from: item['from'],
                      till: item['till'],
                    ),
                  )
                  .toList(),
        ));
      });
      _items = loadedEmployees;
      notifyListeners();
    // } catch (error) {
    //   throw (error);
    // }
  }
}
