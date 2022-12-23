final String tableWorkers = 'workers';

class Worker {
  final int? id;
  final String place;
  final String name;
  final int a, b, c;

  const Worker(
      {this.id,
      required this.place,
      required this.name,
      required this.a,
      required this.b,
      required this.c});

  Map<String, Object?> toJson() => {
        WorkerFields.id: id,
        WorkerFields.name: name,
        WorkerFields.place: place,
        WorkerFields.a: a,
        WorkerFields.b: b,
        WorkerFields.c: c,
      };

  static Worker fromJson(Map<String, Object?> json) => Worker(
        id: json[WorkerFields.id] as int?,
        name: json[WorkerFields.name] as String,
        place: json[WorkerFields.place] as String,
        a: json[WorkerFields.a] as int,
        b: json[WorkerFields.b] as int,
        c: json[WorkerFields.c] as int,
      );

  Worker copy({int? id, String? name, String? place, int? a, b, c}) => Worker(
      id: id ?? this.id,
      name: name ?? this.name,
      place: place ?? this.place,
      a: a ?? this.a,
      b: b ?? this.b,
      c: c ?? this.c);
}

class WorkerFields {
  static final List<String> values = [id, name, place, a, b, c];

  static final String id = '_id';
  static final String place = 'place';
  static final String name = 'name';
  static final String a = 'a';
  static final String b = 'b';
  static final String c = 'c';
}
// final String tableWorkers = 'workers';

// class Worker {
//   final int? id;
//   final String place;
//   final String name;
//   final String a;
//   final String b;
//   final String c;

//   const Worker(
//       {this.id,
//       required this.place,
//       required this.name,
//       required this.a,
//       required this.b,
//       required this.c});

//   Map<String, Object?> toJson() => {
//         WorkerFields.id: id,
//         WorkerFields.name: name,
//         WorkerFields.place: place,
//         WorkerFields.a: a,
//         WorkerFields.b: b,
//         WorkerFields.c: c,
//       };

//   static Worker fromJson(Map<String, Object?> json) => Worker(
//         id: json[WorkerFields.id] as int?,
//         name: json[WorkerFields.name] as String,
//         place: json[WorkerFields.place] as String,
//         a: json[WorkerFields.a] as String,
//         b: json[WorkerFields.b] as String,
//         c: json[WorkerFields.c] as String,
//       );

//   Worker copy(
//           {int? id,
//           String? name,
//           String? place,
//           String? a,
//           String? b,
//           String? c}) =>
//       Worker(
//           id: id ?? this.id,
//           name: name ?? this.name,
//           place: place ?? this.place,
//           a: a ?? this.a,
//           b: b ?? this.b,
//           c: c ?? this.c);
// }

// class WorkerFields {
//   static final List<String> values = [id, name, place, a, b, c];

//   static final String id = '_id';
//   static final String place = 'place';
//   static final String name = 'name';
//   static final String a = 'a';
//   static final String b = 'b';
//   static final String c = 'c';
// }
