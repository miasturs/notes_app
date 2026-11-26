# notes_app — Ejercicio 3.2 (Drift)

```bash
flutter create .            # (solo si falta android/ios) genera plataformas sin pisar lib/
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```
`build_runner` genera `app_database.g.dart` y `notas_dao.g.dart`. Sube esos `.g.dart` al entregar.

Consulta requerida: `NotasDao.notasPorCategoria(categoriaId)` (orden por fecha DESC).
