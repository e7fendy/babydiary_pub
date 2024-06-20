import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import '../data/record_data.dart';
import '../data/child_data.dart';

class DataManager {
  static final DataManager _instance = DataManager._internal();

  factory DataManager() => _instance;

  static Database? _database;

  DataManager._internal();

  static List<String> types = ["Fever", "Drug", "Vaccine", "Clinic", "Hospital"];
  static Map<String, IconData> typeIcons = {
    "Drug": Icons.medication_liquid,
    "Hospital": Icons.local_hospital,
    "Clinic": Icons.emergency,
    "Fever": Icons.sick,
    "Vaccine": Icons.vaccines
  };

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'babydiary.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS record_data (
        id INTEGER PRIMARY KEY,
        child_id INTEGER,
        type TEXT,
        note TEXT,
        created_at INTEGER DEFAULT (strftime('%s', 'now'))
      )
      '''
    );

    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS children_data (
        id INTEGER PRIMARY KEY,
        gender TEXT,
        name TEXT,
        photo_path TEXT,
        note TEXT,
        created_at INTEGER DEFAULT (strftime('%s', 'now'))
      )
      ''',
    );
  }

  Future<int> insertRecordData(RecordData data) async {
    Database db = await database;
    return await db.insert('record_data', data.toMap());
  }

  Future<List<RecordData>> getRecordData(int childId) async {
    Database db = await database;
    var queryResult = await db.query(
        'record_data',
        where: 'child_id = ?',
        whereArgs: [childId],
        orderBy: 'id desc');
    List<RecordData> result = queryResult.isNotEmpty
        ? queryResult.map((element) => RecordData.fromMap(element)).toList()
        : [];
    return result;
  }

  Future<int> deleteRecordDataById(int? id) async {
    Database db = await database;
    return await db.delete(
      'record_data',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertChildData(ChildData data) async {
    Database db = await database;
    print(data.toMap());
    return await db.insert('children_data', data.toMap());
  }

  Future<int> updateChildData(ChildData data) async {
    Database db = await database;
    return await db.update(
      'children_data',
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  Future<int> deleteChildDataById(int? id) async {
    Database db = await database;
    return await db.delete(
      'children_data',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ChildData>> getChildrenData() async {
    Database db = await database;
    var queryResult = await db.query('children_data', orderBy: 'id');
    List<ChildData> result = queryResult.isNotEmpty
        ? queryResult.map((element) => ChildData.fromMap(element)).toList()
        : [];
    return result;
  }
}

// Future<int> updateNote(Note note) async {
//   Database db = await database;
//   return await db.update(
//     'notes',
//     note.toMap(),
//     where: 'id = ?',
//     whereArgs: [note.id],
//   );
// }
//
// Future<int> deleteNote(int id) async {
//   Database db = await database;
//   return await db.delete(
//     'notes',
//     where: 'id = ?',
//     whereArgs: [id],
//   );
// }