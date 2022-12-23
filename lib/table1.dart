import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trpokp/table2.dart';
import 'database.dart';
import 'worker.dart';

class TableOne extends StatefulWidget {
  const TableOne({super.key});

  @override
  State<TableOne> createState() => _TableOneState();
}

class _TableOneState extends State<TableOne> {
  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  final _aController = TextEditingController();
  final _bController = TextEditingController();
  final _cController = TextEditingController();
  final _yController = TextEditingController();
  final _categoryController = TextEditingController();
  final _xController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late List<Worker> selectedWorkers;
  List<Worker> _workers = [];
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    super.initState();
    bool selected = false;
    super.initState();
    selectedWorkers = [];
    _workers = [];
    getWorkers();
  }

  getWorkers() {
    WorkersDatabase.instance.readAllWorkers().then((workers) {
      setState(() {
        _workers = workers;
        print(workers);
      });
    });
  }

  addWorker(Worker wk) {
    WorkersDatabase.instance.create(wk).then((id) {
      _nameController.clear();
      _placeController.clear();
      _aController.clear();
      _bController.clear();
      _cController.clear();
      print('added to ${id}');
      getWorkers();
    });
  }

  // onSelectedRow(bool selected, Worker worker) async {
  //   setState(() {
  //     if (selected) {
  //       selectedWorkers.add(worker);
  //     } else {
  //       selectedWorkers.remove(worker);
  //     }
  //   });
  // }

  decreaseX(int x, String category) {
    //double percent = 0.01;
    if (category == 'A' || category == 'a') {
      //Worker worker = Worker(place: place, name: name, a: a, b: b, c: c);
      _workers.forEach((element) {
        Worker workerNew = Worker(
            place: element.place,
            name: element.name,
            a: (element.a - ((element.a * x) ~/ 100)),
            b: element.b,
            c: element.c);
        WorkersDatabase.instance.create(workerNew);
        WorkersDatabase.instance.delete(element.id!);
      });
    } else if (category == 'B' || category == 'b') {
      _workers.forEach((element) {
        Worker workerNew = Worker(
            place: element.place,
            name: element.name,
            a: element.a,
            b: (element.b - ((element.b * x) ~/ 100)),
            c: element.c);
        WorkersDatabase.instance.create(workerNew);
        WorkersDatabase.instance.delete(element.id!);
      });
    } else if (category == 'C' || category == 'c') {
      _workers.forEach((element) {
        Worker workerNew = Worker(
            place: element.place,
            name: element.name,
            a: element.c,
            b: element.b,
            c: (element.c - ((element.c * x) ~/ 100)));
        WorkersDatabase.instance.create(workerNew);
        WorkersDatabase.instance.delete(element.id!);
      });
    }
    getWorkers();
  }

  deleteUnderY(int y, String category) {
    if (category == 'A' || category == 'a') {
      _workers.forEach((element) {
        if (element.a < y) {
          WorkersDatabase.instance.delete(element.id!);
        }
      });
    } else if (category == 'B' || category == 'b') {
      _workers.forEach((element) {
        if (element.b < y) {
          WorkersDatabase.instance.delete(element.id!);
        }
      });
    } else if (category == 'C' || category == 'c') {
      _workers.forEach((element) {
        if (element.c < y) {
          WorkersDatabase.instance.delete(element.id!);
        }
      });
    }
    getWorkers();
  }

  int count(String forCount) {
    int sum = 0;
    if (forCount == 'A') {
      _workers.forEach((element) {
        sum += element.a;
      });
    } else if (forCount == 'B') {
      _workers.forEach((element) {
        sum += element.b;
      });
    } else if (forCount == 'C') {
      _workers.forEach((element) {
        sum += element.c;
      });
    } else if (forCount == 'Всего') {
      _workers.forEach((element) {
        sum += element.a + element.c + element.b;
      });
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool _sortNameAsc = true;
    bool _sortAgeAsc = true;
    bool _sortHightAsc = true;
    bool _sortAsc = true;

    int compareString(bool ascending, String value1, String value2) =>
        ascending ? value1.compareTo(value2) : value2.compareTo(value1);

    int compareInt(bool ascending, int value1, int value2) =>
        ascending ? value1.compareTo(value2) : value2.compareTo(value1);

    checkVars(var name, var place, var a, var b, var c) {
      try {
        String n = name;
        String p = place;
        int.parse(a);
        int.parse(b);
        int.parse(c);
      } catch (e) {
        AlertDialog(
          scrollable: true,
          title: Text(
              'Проверьте, что в поля "Name" и "Place" введены буквы, а в поля A, B, C - цифры'),
          content: const Padding(padding: EdgeInsets.all(8.0)),
          actions: [
            TextButton(
                child: Text("Submit", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      }
    }

    void onSort(int columnIndex, bool ascending) {
      if (columnIndex == 0) {
        _workers.sort(
            (user1, user2) => compareString(ascending, user1.name, user2.name));
      } else if (columnIndex == 1) {
        _workers.sort((user1, user2) =>
            compareString(ascending, user1.place, user2.place));
      } else if (columnIndex == 2) {
        _workers
            .sort((user1, user2) => compareInt(ascending, user1.a, user2.a));
      } else if (columnIndex == 3) {
        _workers
            .sort((user1, user2) => compareInt(ascending, user1.b, user2.b));
      } else if (columnIndex == 4) {
        _workers
            .sort((user1, user2) => compareInt(ascending, user1.c, user2.c));
      }
      setState(() {
        this.sortColumnIndex = columnIndex;
        this.isAscending = ascending;
      });
    }

    SizedBox dataBody() {
      return SizedBox(
        height: height * 0.64,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 50,
              sortColumnIndex: 0,
              columns: [
                DataColumn(
                    label: Text('Name'),
                    tooltip: 'This is the last name',
                    onSort: onSort),
                DataColumn(label: Text('Place'), onSort: onSort),
                DataColumn(label: Text('A'), onSort: onSort),
                DataColumn(label: Text('B'), onSort: onSort),
                DataColumn(label: Text('C'), onSort: onSort),
                DataColumn(
                  label: Text('Upgrade'),
                ),
                DataColumn(
                  label: Text('Delete'),
                ),
              ],
              rows: _workers
                  .map((worker) => DataRow(
                          selected: selectedWorkers.contains(worker),
                          cells: [
                            DataCell(
                              Text(worker.name),
                            ),
                            DataCell(
                              Text(worker.place),
                            ),
                            DataCell(Text('${worker.a}')),
                            DataCell(Text('${worker.b}')),
                            DataCell(Text('${worker.c}')),
                            DataCell(IconButton(
                              icon: Icon(Icons.transfer_within_a_station),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Form(
                                        key: _formKey,
                                        child: AlertDialog(
                                          scrollable: true,
                                          title: const Text('Insert'),
                                          content: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                children: <Widget>[
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                      hintText: worker.name,
                                                      labelText: 'Name',
                                                      icon: Icon(
                                                          Icons.account_box),
                                                    ),
                                                    controller: _nameController,
                                                    validator: (String?
                                                            value) =>
                                                        (value == null ||
                                                                value.isEmpty)
                                                            ? 'Name Should Not Be Empty'
                                                            : null,
                                                  ),
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                      hintText: worker.place,
                                                      labelText: 'Place',
                                                      icon: Icon(Icons.home),
                                                    ),
                                                    controller:
                                                        _placeController,
                                                    validator: (String?
                                                            value) =>
                                                        (value == null ||
                                                                value.isEmpty)
                                                            ? 'Place Should Not Be Empty'
                                                            : null,
                                                  ),
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          worker.a.toString(),
                                                      labelText: 'A',
                                                      icon: const Icon(
                                                          Icons.handyman),
                                                    ),
                                                    controller: _aController,
                                                    validator: (var value) =>
                                                        (value == null ||
                                                                value.isEmpty)
                                                            ? 'A Should Not Be Empty'
                                                            : null,
                                                  ),
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          worker.b.toString(),
                                                      labelText: 'B',
                                                      icon: const Icon(
                                                          Icons.handyman),
                                                    ),
                                                    controller: _bController,
                                                    validator: (var value) =>
                                                        (value == null ||
                                                                value.isEmpty)
                                                            ? 'B Should Not Be Empty'
                                                            : null,
                                                  ),
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          worker.c.toString(),
                                                      labelText: 'C',
                                                      icon: const Icon(
                                                          Icons.handyman),
                                                    ),
                                                    controller: _cController,
                                                    validator: (var value) =>
                                                        (value == null ||
                                                                value.isEmpty)
                                                            ? 'C Should Not Be Empty'
                                                            : null,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                                child: const Text("Submit"),
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    WorkersDatabase.instance
                                                        .delete(worker.id!);
                                                    Worker wk = Worker(
                                                        name: _nameController
                                                            .text,
                                                        place: _placeController
                                                            .text,
                                                        a: int.parse(
                                                            _aController.text),
                                                        b: int.parse(
                                                            _bController.text),
                                                        c: int.parse(
                                                            _cController.text));
                                                    WorkersDatabase.instance
                                                        .create(wk)
                                                        .then((id) {
                                                      _nameController.clear();
                                                      _placeController.clear();
                                                      _aController.clear();
                                                      _bController.clear();
                                                      _cController.clear();
                                                      print('added to ${id}');
                                                      getWorkers();
                                                    });
                                                    Navigator.of(context).pop();
                                                  }
                                                })
                                          ],
                                        ),
                                      );
                                    });
                              },
                            )),
                            DataCell(IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                WorkersDatabase.instance.delete(worker.id!);
                                getWorkers();
                              },
                            ))
                          ]))
                  .toList(),
            ),
          ),
        ),
      );
    }

    buttonCreate(String text) {
      return TextButton(
        style: ButtonStyle(
          enableFeedback: false,
          backgroundColor: MaterialStateProperty.all(Colors.lime),
        ),
        onPressed: () {
          if (text == 'Insert') {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Form(
                    key: _formKey,
                    child: AlertDialog(
                      scrollable: true,
                      title: const Text('Insert'),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                icon: Icon(Icons.account_box),
                              ),
                              controller: _nameController,
                              validator: (String? value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Name Should Not Be Empty'
                                      : null,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Place',
                                icon: Icon(Icons.home),
                              ),
                              controller: _placeController,
                              validator: (String? value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Place Should Not Be Empty'
                                      : null,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'A',
                                icon: Icon(Icons.handyman),
                              ),
                              controller: _aController,
                              validator: (var value) =>
                                  (value == null || value.isEmpty)
                                      ? 'A Should Not Be Empty'
                                      : null,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'B',
                                icon: Icon(Icons.handyman),
                              ),
                              controller: _bController,
                              validator: (var value) =>
                                  (value == null || value.isEmpty)
                                      ? 'B Should Not Be Empty'
                                      : null,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'C',
                                icon: Icon(Icons.handyman),
                              ),
                              controller: _cController,
                              validator: (var value) =>
                                  (value == null || value.isEmpty)
                                      ? 'C Should Not Be Empty'
                                      : null,
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                            child: const Text("Submit",
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              //_submitWorker(context);

                              if (_formKey.currentState!.validate()) {
                                Worker wk = Worker(
                                    name: _nameController.text,
                                    place: _placeController.text,
                                    a: int.parse(_aController.text),
                                    b: int.parse(_bController.text),
                                    c: int.parse(_cController.text));
                                addWorker(wk);

                                Navigator.of(context).pop();
                              }
                            })
                      ],
                    ),
                  );
                });
          } else if (text == 'Delete under Y') {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Form(
                    key: _formKey,
                    child: AlertDialog(
                      scrollable: true,
                      title: Text('Insert Y'),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Y',
                                icon: Icon(Icons.manage_history),
                              ),
                              controller: _yController,
                              validator: (String? value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Y Should Not Be Empty'
                                      : null,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Category',
                                icon: Icon(Icons.account_box),
                              ),
                              controller: _categoryController,
                              validator: (String? value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Category Should Not Be Empty'
                                      : null,
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                            child: Text("Submit",
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              //_submitWorker(context);
                              if (_formKey.currentState!.validate()) {
                                deleteUnderY(int.parse(_yController.text),
                                    _categoryController.text);
                                _categoryController.clear();
                                _yController.clear();
                                Navigator.of(context).pop();
                              }
                              // Navigator.of(context).pop();
                            })
                      ],
                    ),
                  );
                });
          } else if (text == 'Decrease X%') {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Text('Decrease X%'),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _xController,
                              decoration: const InputDecoration(
                                labelText: 'Input X',
                                icon: Icon(Icons.update),
                              ),
                            ),
                            TextFormField(
                              controller: _categoryController,
                              decoration: const InputDecoration(
                                labelText: 'Input category',
                                icon: Icon(Icons.update),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                          child: const Text(
                            "Submit",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            decreaseX(int.parse(_xController.text),
                                _categoryController.text);
                            _xController.clear();
                            _categoryController.clear();
                            Navigator.of(context).pop();
                          })
                    ],
                  );
                });
          }
        },
        child: Text(
          '$text',
          style: TextStyle(color: Colors.black),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Worker Manager',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.lime,
        actions: [
          IconButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => TableTwo()));
            },
            icon: Icon(Icons.list),
          ),
        ],
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        dataBody(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(child: Text('Total: ${count('Всего')}')),
                Text('A: ${count('A')}'),
                Container(child: Text('В: ${count('B')}')),
                Container(child: Text('C: ${count('C')}')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonCreate('Insert'),
                buttonCreate('Decrease X%'),
                buttonCreate('Delete under Y')
              ],
            ),
          ],
        ),
        SizedBox(
          height: height * 0.007,
        )
      ]),
    );
  }
}

// //import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:trpokp/table2.dart';
// //import 'package:flutter/src/widgets/container.dart';
// //import 'package:flutter/src/widgets/framework.dart';
// //import 'database.dart';
// import 'table12.dart';
// //import 'worker.dart';
// import 'dbmanager.dart';

// class TableOne extends StatefulWidget {
//   const TableOne({super.key});

//   @override
//   State<TableOne> createState() => _TableOneState();
// }

// class _TableOneState extends State<TableOne> {
//   final _nameController = TextEditingController();
//   final _placeController = TextEditingController();
//   final _aController = TextEditingController();
//   final _bController = TextEditingController();
//   final _cController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   //Future<List<Worker>> workers = WorkersDatabase.instance.readAllWorkers();
//   late List<Worker> selectedWorkers;
//   //late Worker _selectedWorker;
//   //late bool sort;
//   List<Worker> _workers = [];
//   DbWorkerManager ddb = DbWorkerManager();

//   @override
//   void initState() {
//     super.initState();
//     // TODO: implement initState
// //sort = false;
//     //workers = [];
//     bool selected = false;
//     super.initState();
//     selectedWorkers = [];
//     // _workers = [];
//     // getWorkers();
//   }

//   getWorkers() {
//     ddb.getWorkerList().then((worker) {
//       setState(() {
//         _workers = worker;
//       });
//     });
//   }

//   // deleteWorker(Worker worker) {
//   //   ddb.deleteWorker(worker.id!);

//   onSelectedRow(bool selected, Worker worker) async {
//     setState(() {
//       if (selected) {
//         selectedWorkers.add(worker);
//       } else {
//         selectedWorkers.remove(worker);
//       }
//     });
//   }

//   // onSortColumn(int columnIndex, bool ascending) async {
//   //   if (0 == columnIndex) {
//   //     if (ascending) {
//   //       workers.sort(((a, b) => a.name.compareTo(b.name)));
//   //     } else {
//   //       workers.sort(((a, b) => b.name.compareTo(a.name)));
//   //     }
//   //   }
//   // }

//   SingleChildScrollView dataBody() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: DataTable(
//           columnSpacing: 50,
//           //sortAscending: sort,
//           sortColumnIndex: 0,
//           columns: const [
//             DataColumn(label: Text('Name'), tooltip: 'This is the last name'),
//             DataColumn(label: Text('Place')),
//             DataColumn(label: Text('A')),
//             DataColumn(label: Text('B')),
//             DataColumn(label: Text('C')),
//             DataColumn(
//               label: Text('Upgrade'),
//             ),
//             DataColumn(
//               label: Text('Delete'),
//             ),
//           ],
//           rows: _workers
//               .map((worker) => DataRow(
//                       selected: selectedWorkers.contains(worker),
//                       onSelectChanged: (b) {
//                         //onSelectedRow(b, worker);
//                       },
//                       cells: [
//                         DataCell(
//                           Text(worker.name),
//                         ),
//                         DataCell(
//                           Text(worker.place),
//                         ),
//                         DataCell(Text(worker.a)),
//                         DataCell(Text(worker.b)),
//                         DataCell(Text(worker.c)),
//                         DataCell(IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () {},
//                         )),
//                         DataCell(IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () {},
//                         ))
//                       ]))
//               .toList(),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;

//     buttonCreate(String text) {
//       return TextButton(
//         style: ButtonStyle(
//           enableFeedback: false,
//           backgroundColor: MaterialStateProperty.all(Colors.lime),
//         ),
//         onPressed: () {
//           if (text == 'Insert') {
//             showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return Form(
//                     key: _formKey,
//                     child: AlertDialog(
//                       scrollable: true,
//                       title: const Text('Insert'),
//                       content: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: <Widget>[
//                             TextFormField(
//                               decoration: const InputDecoration(
//                                 labelText: 'Name',
//                                 icon: Icon(Icons.account_box),
//                               ),
//                               controller: _nameController,
//                               validator: (String? value) =>
//                                   (value == null || value.isEmpty)
//                                       ? 'Name Should Not Be Empty'
//                                       : null,
//                             ),
//                             TextFormField(
//                               decoration: const InputDecoration(
//                                 labelText: 'Place',
//                                 icon: Icon(Icons.home),
//                               ),
//                               controller: _placeController,
//                               validator: (String? value) =>
//                                   (value == null || value.isEmpty)
//                                       ? 'Place Should Not Be Empty'
//                                       : null,
//                             ),
//                             TextFormField(
//                               decoration: const InputDecoration(
//                                 labelText: 'A',
//                                 icon: Icon(Icons.handyman),
//                               ),
//                               controller: _aController,
//                               validator: (var value) =>
//                                   (value == null || value.isEmpty)
//                                       ? 'A Should Not Be Empty'
//                                       : null,
//                             ),
//                             TextFormField(
//                               decoration: const InputDecoration(
//                                 labelText: 'B',
//                                 icon: Icon(Icons.handyman),
//                               ),
//                               controller: _bController,
//                               validator: (var value) =>
//                                   (value == null || value.isEmpty)
//                                       ? 'B Should Not Be Empty'
//                                       : null,
//                             ),
//                             TextFormField(
//                               decoration: const InputDecoration(
//                                 labelText: 'C',
//                                 icon: Icon(Icons.handyman),
//                               ),
//                               controller: _cController,
//                               validator: (var value) =>
//                                   (value == null || value.isEmpty)
//                                       ? 'C Should Not Be Empty'
//                                       : null,
//                             ),
//                           ],
//                         ),
//                       ),
//                       actions: [
//                         TextButton(
//                             child: const Text("Submit"),
//                             onPressed: () {
//                               //_submitWorker(context);
//                               if (_formKey.currentState!.validate()) {
//                                 Worker wk = Worker(
//                                     name: _nameController.text,
//                                     place: _placeController.text,
//                                     a: _aController.text,
//                                     b: _bController.text,
//                                     c: _cController.text);
//                                 ddb.insertWorker(wk).then((id) {
//                                   _nameController.clear();
//                                   _placeController.clear();
//                                   _aController.clear();
//                                   _bController.clear();
//                                   _cController.clear();
//                                   print('added to $id');
//                                   //print('${worker.a}')
//                                 });

//                                 Navigator.of(context).pop();
//                               }
//                             })
//                       ],
//                     ),
//                   );
//                 });
//           } else if (text == 'Delete under Y') {
//             showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return Form(
//                     key: _formKey,
//                     child: AlertDialog(
//                       scrollable: true,
//                       title: Text('Insert Y'),
//                       content: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: <Widget>[
//                             TextFormField(
//                               decoration: InputDecoration(
//                                 labelText: 'Y',
//                                 icon: Icon(Icons.account_box),
//                               ),
//                               controller: _nameController,
//                               validator: (String? value) =>
//                                   (value == null || value.isEmpty)
//                                       ? 'Y Should Not Be Empty'
//                                       : null,
//                             ),
//                           ],
//                         ),
//                       ),
//                       actions: [
//                         TextButton(
//                             child: Text("Submit"),
//                             onPressed: () {
//                               //_submitWorker(context);
//                               if (_formKey.currentState!.validate()) {
//                                 Navigator.of(context).pop();
//                               }
//                               // Navigator.of(context).pop();
//                             })
//                       ],
//                     ),
//                   );
//                 });
//           } else if (text == 'Decrease X%') {
//             showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     scrollable: true,
//                     title: Text('Decrease X%'),
//                     content: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Form(
//                         child: Column(
//                           children: <Widget>[
//                             TextFormField(
//                               decoration: InputDecoration(
//                                 labelText: 'Input X',
//                                 icon: Icon(Icons.update),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     actions: [
//                       TextButton(
//                           child: Text("Submit"),
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           })
//                     ],
//                   );
//                 });
//           } else if (text == 'Sort') {
//             showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     scrollable: true,
//                     title: Text('Sort'),
//                     content: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Form(
//                         child: Column(
//                           children: <Widget>[
//                             TextFormField(
//                               decoration: const InputDecoration(
//                                 labelText: 'Input column',
//                                 icon: Icon(Icons.auto_awesome),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     actions: [
//                       TextButton(
//                           child: Text("Submit"),
//                           onPressed: () {
//                             //_submitWorker(context);
//                             Navigator.of(context).pop();
//                           })
//                     ],
//                   );
//                 });
//           }
//         },
//         child: Text(
//           '$text',
//           style: TextStyle(color: Colors.black),
//         ),
//       );
//     }

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: SizedBox(
//           width: width * 0.9,
//           height: height,
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 dataBody(),
//                 SizedBox(
//                   height: height * 0.3,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Container(child: Text('Всего:')),
//                           Text('A:'),
//                           Container(child: Text('В:')),
//                           Container(child: Text('C:')),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           buttonCreate('Insert'),
//                           buttonCreate('Decrease X%'),
//                           buttonCreate('Delete under Y'),
//                           buttonCreate('Sort'),
//                         ],
//                       ),
//                       ElevatedButton(
//                           onPressed: () {
//                             getWorkers();
//                           },
//                           child: Text('ff')),
//                       ElevatedButton(
//                           onPressed: () {
//                             Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => TableTwo()));
//                           },
//                           child: Text('Ведомость ЗП')),
//                     ],
//                   ),
//                 ),
//               ]),
//         ),
//       ),
//     );
//   }
//}
