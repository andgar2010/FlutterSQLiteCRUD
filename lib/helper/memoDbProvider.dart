import 'dart:async';
import 'dart:io';

import 'package:path/path.dart'; //used to join paths
import 'package:path_provider/path_provider.dart'; //path_provider package
import 'package:sqflite/sqflite.dart'; //sqflite package

import '../model/memoModel.dart'; //import model class

class MemoDbProvider {
  MemoDbProvider({this.nameTable = 'Memos'});
  final String nameTable;

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path = join(directory.path, "$nameTable.db"); //create path to database

    //open the database or create a database if there isn't any
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("""
        CREATE TABLE $nameTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT)""");
      },
    );
  }

  //returns number of items inserted as an integer
  Future<int> addItem(MemoModel item) async {
    final db = await init(); //open database
    return db.insert(
      "$nameTable",
      item.toMap(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  //returns the memos as a list (array)
  Future<List<MemoModel>> fetchMemos() async {
    final db = await init();
    final maps = await db.query("$nameTable"); //query all the rows in a table as an array of maps

    return List.generate(
      maps.length,
      (i) {
        print('number index: $i');
        //create a list of memos
        return MemoModel(
          id: maps[i]['id'],
          title: maps[i]['title'],
          content: maps[i]['content'],
        );
      },
    );
  }

  // returns number of items deleted
  Future<int> deleteMemo(int id) async {
    final db = await init();
    int result = await db.delete('$nameTable', where: "id = ?", whereArgs: [id]);
    return result;
  }

  // returns the number of rows updated
  Future<int> updateMemos(int id, MemoModel item) async {
    final db = await init();
    int result = await db.update('$nameTable', item.toMap(), where: 'id = ?', whereArgs: [id]);
    return result;
  }
}
