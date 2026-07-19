import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TaskLocalDatasource {
  //Creamos nuestra base de datos
  Future<Database> _openDb() async{
    return openDatabase(
      join(await getDatabasesPath(), 'taskflow.db'),
      onCreate: (db, version) => db.execute(
        'CREATE TABLE tasks(id TEXT PRIMARY KEY, title TEXT, done INTEGER)'
      ),
      version: 1
    );
  }

  Future<void> cacheTasks(List<Map<String, dynamic>> tasks) async{
    final db = await _openDb();
    final batch = db.batch();
    for (final t in tasks){
      batch.insert('tasks', t, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future<List<Map<String, dynamic>>> getCachedTasks() async{
    final db = await _openDb();
    return db.query('tasks');
  }
  
}