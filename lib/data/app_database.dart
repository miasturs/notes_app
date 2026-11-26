import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'daos/notas_dao.dart';
import 'tables/categorias.dart';
import 'tables/notas.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Categorias, Notas], daos: [NotasDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // Seed de categorías iniciales
          await batch((b) {
            b.insertAll(categorias, [
              CategoriasCompanion.insert(nombre: 'Personal', color: 0xFF6C5CE7),
              CategoriasCompanion.insert(nombre: 'Trabajo', color: 0xFF00B894),
              CategoriasCompanion.insert(nombre: 'Ideas', color: 0xFFE17055),
            ]);
          });
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'notes.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
