import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/categorias.dart';
import '../tables/notas.dart';

part 'notas_dao.g.dart';

@DriftAccessor(tables: [Notas, Categorias])
class NotasDao extends DatabaseAccessor<AppDatabase> with _$NotasDaoMixin {
  NotasDao(super.db);

  // 🔹 Consulta requerida: notas por categoría, ordenadas por fecha DESC
  Future<List<Nota>> notasPorCategoria(int categoriaId) {
    return (select(notas)
          ..where((n) => n.categoriaId.equals(categoriaId))
          ..orderBy([(n) => OrderingTerm(expression: n.fecha, mode: OrderingMode.desc)]))
        .get();
  }

  // 🔹 JOIN opcional: notas con su categoría (para UI)
  Future<List<NotaConCategoria>> notasConCategoria() {
    final query = select(notas).join([
      innerJoin(categorias, categorias.id.equalsExp(notas.categoriaId)),
    ])
      ..orderBy([OrderingTerm.desc(notas.fecha)]);

    return query.map((row) {
      return NotaConCategoria(
        nota: row.readTable(notas),
        categoria: row.readTable(categorias),
      );
    }).get();
  }

  // 🔹 CRUD de categorías (bonus)
  Future<int> insertarCategoria(CategoriasCompanion c) =>
      into(categorias).insert(c);

  // 🔹 CRUD de notas (bonus)
  Future<int> insertarNota(NotasCompanion n) => into(notas).insert(n);

  Future<bool> actualizarNota(Nota n) => update(notas).replace(n);

  Future<int> eliminarNota(int id) =>
      (delete(notas)..where((n) => n.id.equals(id))).go();
}

class NotaConCategoria {
  final Nota nota;
  final Categoria categoria;
  NotaConCategoria({required this.nota, required this.categoria});
}
