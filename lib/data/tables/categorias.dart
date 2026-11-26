import 'package:drift/drift.dart';

class Categorias extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 50)();
  IntColumn get color => integer()(); // ARGB, ej: 0xFFFF0000
}
