// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../providers/employee.dart';
// import '../providers/emloyees.dart';

// class AddEmployScreen extends StatefulWidget {
//   static const routeName = '/add-Employee';

//   @override
//   _AddEmployScreenState createState() => _AddEmployScreenState();
// }

// class _AddEmployScreenState extends State<AddEmployScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final _form = GlobalKey<FormState>();

//     final nameController = TextEditingController();

//     final idController = TextEditingController();

//     var _addEmployee = Employee(
//       id: '',
//       name: '',
//     );

//     Future<void> _saveForm() async {
//       final isValid = _form.currentState.validate();
//       if (!isValid) {
//         return;
//       }

//       try {
//         await Provider.of<Employees>(context, listen: false)
//             .addemployee(_addEmployee);
//       } catch (error) {
//         print(error);
//         // await showDialog(
//         //     context: context,
//         //     builder: (BuildContext context) {

//         //       return AlertDialog(
//         //         title: Text('An error occurred!'),
//         //         content: Text('Something went wrong.'),
//         //         actions: <Widget>[
//         //           FlatButton(
//         //             child: Text('Okay'),
//         //             onPressed: () {
//         //               Navigator.of(context).pop();
//         //             },
//         //           )
//         //         ],
//         //       );
//         //     });
//       }

//       Navigator.of(context).pop();
//       // Navigator.of(context).pop();
//     }

//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text(' Product'),
//           actions: <Widget>[
//             IconButton(
//               icon: Icon(Icons.save),
//               onPressed: () => {print(_addEmployee.name), _saveForm},
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _form,
//             child: ListView(
//               children: <Widget>[
//                 TextFormField(
//                   controller: nameController,
//                   decoration: InputDecoration(labelText: 'Name'),
//                   textInputAction: TextInputAction.next,
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Please provide a value.';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     _addEmployee = Employee(
//                       name: value,
//                       id: _addEmployee.id,
//                     );
//                   },
//                 ),
//                 TextFormField(
//                   controller: idController,
//                   decoration: InputDecoration(labelText: 'Employee id'),
//                   textInputAction: TextInputAction.next,
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Please provide a value.';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     _addEmployee = Employee(
//                       name: _addEmployee.name,
//                       id: value,
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//   }
// }

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/employee.dart';
import '../providers/emloyees.dart';
import '../providers/scheduleItem.dart';

class AddEmployeeScreen extends StatefulWidget {
  static const routeName = '/add-employee';

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _form = GlobalKey<FormState>();

  final format = DateFormat("yyyy-MM-dd");

  final dateController = TextEditingController();

  final fromController = TextEditingController();

  final tillController = TextEditingController();

  final nameController = TextEditingController();

  final idController = TextEditingController();

  var _addEmployee = Employee(
    id: '',
    name: '',
    schedule: [],
  );

  var _addSchedule =
      EmployeeSchedule(id: DateTime.now().toString(), date: null, from: null, till: null);

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    try {
      await Provider.of<Employees>(context, listen: false)
          .addemployee(_addEmployee, [_addSchedule]);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text(error.toString()),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
    // print(nameController.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _addEmployee = Employee(
                      name: value,
                      id: _addEmployee.id,
                      schedule: _addEmployee.schedule);
                },
              ),
              TextFormField(
                controller: idController,
                decoration: InputDecoration(labelText: 'Employee id'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _addEmployee = Employee(
                      name: _addEmployee.name,
                      id: value,
                      schedule: _addEmployee.schedule);
                },
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (ctx, i) => Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                      children: <Widget>[
                        DateTimeField(
                          format: format,
                          controller: dateController,
                          decoration: InputDecoration(labelText: 'Date'),
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                          },
                          onSaved: (value) {
                            _addSchedule = EmployeeSchedule(
                              id: _addSchedule.id,
                              date: value.toString(),
                              from: _addSchedule.from,
                              till: _addSchedule.till,
                            );
                          },
                        ),
                        DateTimeField(
                          format: format,
                          controller: fromController,
                          decoration:
                              InputDecoration(labelText: 'starting work time'),
                          onShowPicker: (context, currentValue) async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.convert(time);
                          },
                          onSaved: (value) {
                            _addSchedule = EmployeeSchedule(
                              id: _addSchedule.id,
                              date: _addSchedule.date,
                              from: value.toString(),
                              till: _addSchedule.till,
                            );
                          },
                        ),
                        DateTimeField(
                          format: format,
                          controller: tillController,
                          decoration:
                              InputDecoration(labelText: 'Ending work time'),
                          onShowPicker: (context, currentValue) async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.convert(time);
                          },
                          onSaved: (value) {
                            _addSchedule = EmployeeSchedule(
                              id: _addSchedule.id,
                              date: _addSchedule.date,
                              from: _addSchedule.from,
                              till: value.toString(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
