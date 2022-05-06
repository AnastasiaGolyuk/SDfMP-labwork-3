import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:relax_app/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'relax_app__users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
          id INTEGER PRIMARY KEY,
          username TEXT,
          email TEXT,
          passwordHash TEXT,
          isAuthorized INTEGER,
          avatar BLOB
      )
      ''');
  }

  Future<List<User>> getUsers() async {
    Database db = await instance.database;
    var results = await db.query('users');
    List<User> usersList = results.isNotEmpty
        ? results.map((c) => User.fromJson(c)).toList()
        : [];
    return usersList;
  }

  Future<List<String>?> getUserEmails() async {
    var users = await getUsers();
    List<String> results = List.empty(growable: true);
    for (var element in users) {
      results.add(element.email);
    }
    return results;
  }

  Future<User?> findAuthUser() async {
    var results = await getUsers();
    User? user;
    for (var element in results) {
      if (element.isAuthorized==1){
        user=element;
      }
    }
    return user;
  }


  Future<int> getUsersCount() async {
    var results = await getUsers();
    return results.length;
  }

  Future<int> addUser(User user) async {
    Database db = await instance.database;
    return await db.insert('users', user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> findUser(String email) async {
    var results = await getUsers();
    User? user;
    for (var element in results) {
      if (element.email==email){
        user=element;
      }
    }
    return user;
  }
}
