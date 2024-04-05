// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
//
// import 'model/invoice_model.dart';
//
//
// class DatabaseHelper{
//   static late DatabaseHelper _databaseHelper;
//   static late Database _database;
//
//   DatabaseHelper._createInstance();
//
//   String invoiceTable = 'invoice_table';
//   String colId = 'id';
//   String colName = 'productname';
//   String colType = 'producttype';
//   String colQty = 'productqty';
//   String colAddress = 'address';
//   String colNumber = 'number';
//
//   factory DatabaseHelper(){
//     if(_databaseHelper == null){
//       _databaseHelper =DatabaseHelper._createInstance();
//     }
//     return _databaseHelper;
//   }
//
//  get database async{
//     if(_database == null){
//       _database= await initializeDatabase();
//     }
//     return  _database;
//  }
//
//   initializeDatabase() async{
//     Directory directory = await getApplicationCacheDirectory();
//     String path = directory.path + 'notes.db';
//
//     var notesDatabase =await openDatabase(path,version: 1,onCreate: _createDb);
//     return notesDatabase;
//   }
//
//   void _createDb(Database db,int newVersion) async{
//     await db.execute('CREATE TABLE $invoiceTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colName TEXT,$colType TEXT,$colQty TEXT,$colAddress TEXT,$colNumber TEXT)');
//   }
//
//
//   Future<List<Map<String,dynamic>>> getNoteMapList() async {
//     Database db = await this.database;
//
//     // var result = await db.rawQuery('SELECT * FROM $invoiceTable');
//     var result = await db.query(invoiceTable);
//     return result;
//   }
//
//   Future<int> insertNote(InvoiceModel note) async{
//     Database db = await this.database;
//     var result = await db.insert(invoiceTable, note.toMap());
//     return result;
//   }
//
//   Future<int> updateNote(InvoiceModel note) async{
//     Database db = await this.database;
//     var result = await db.update(invoiceTable, note.toMap(),where: '$colId = ?',whereArgs: [note.id]);
//     return result;
//   }
//
//   Future<int> deleteNote(int id) async{
//     Database db = await this.database;
//     var result = await db.rawDelete('DELETE FROM $invoiceTable WHERE $colId = $id');
//     return result;
//   }
//
// Future<List<InvoiceModel>> getNoteList() async{
//     var noteMapList = await getNoteMapList();
//     int count = noteMapList.length;
//
//     List<InvoiceModel> noteList =  List<InvoiceModel>();
//
//     for(int i =0;i<count;i++){
//       noteList.add(InvoiceModel.fromMapobject(noteMapList[i]));
//     }
//     return noteList;
// }
//
// }

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        gst TEXT,
        producttype TEXT,
        totalprice TEXT,
        discount TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbtech.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(String title, String? descrption, String gst,
      String producttype, String totalprice, String discount) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'gst': gst,
      'producttype': producttype,
      'totalprice': totalprice,
      'discount': discount
    };
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id,
      String title,
      String? descrption,
      String gst,
      String producttype,
      String totalprice,
      String discount) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'gst': gst,
      'producttype': producttype,
      'totalprice': totalprice,
      'discount': discount,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
