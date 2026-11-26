import 'package:drift/drift.dart';
import 'categorias.dart';

class Notas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titulo => text().withLength(min: 1, max: 100)();
  TextColumn get contenido => text()();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
  IntColumn get categoriaId =>
      integer().references(Categorias, #id, onDelete: KeyAction.cascade)();
}
