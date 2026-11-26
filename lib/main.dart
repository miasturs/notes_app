import 'package:flutter/material.dart';
import 'data/app_database.dart';
import 'data/daos/notas_dao.dart' show NotaConCategoria;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Notes (Drift)',
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: const HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = AppDatabase();
  List<NotaConCategoria> items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final r = await db.notasDao.notasConCategoria();
    setState(() => items = r);
  }

  Future<void> _add() async {
    await db.notasDao.insertarNota(NotasCompanion.insert(
      titulo: 'Nota ${DateTime.now().second}',
      contenido: 'Contenido de ejemplo',
      categoriaId: 1,
    ));
    await _load();
  }

  @override
  void dispose() {
    db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Notas')),
        floatingActionButton:
            FloatingActionButton(onPressed: _add, child: const Icon(Icons.add)),
        body: ListView(
          children: [
            for (final i in items)
              ListTile(
                leading: CircleAvatar(backgroundColor: Color(i.categoria.color)),
                title: Text(i.nota.titulo),
                subtitle: Text('${i.categoria.nombre} · ${i.nota.fecha}'),
              ),
          ],
        ),
      );
}
