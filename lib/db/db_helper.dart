import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:relax_app/models/uploaded_image.dart';
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
    String path = join(documentsDirectory.path, 'draft3.db');
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
          dateBirth TEXT,
          isAuthorized INTEGER,
          avatar BLOB
      )
      ''');

    await db.execute('''
      CREATE TABLE uploaded_image(
          id INTEGER PRIMARY KEY,
          idUser INTEGER,
          bytes BLOB,
          timeUpload TEXT
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

  Future<List<UploadedImage>> getImages(int idUser) async {
    Database db = await instance.database;
    var results = await db.query('uploaded_image',where: 'idUser = ?', whereArgs: [idUser]);
    List<UploadedImage> imagesList = results.isNotEmpty
        ? results.map((c) => UploadedImage.fromJson(c)).toList()
        : [];
    return imagesList;
  }

  Future<int> getImagesCount() async {
    Database db = await instance.database;
    var results = await db.query('uploaded_image');
    List<UploadedImage> imagesList = results.isNotEmpty
        ? results.map((c) => UploadedImage.fromJson(c)).toList()
        : [];
    return imagesList.length;
  }

  Future<int> addImage(UploadedImage image) async {
    Database db = await instance.database;
    return await db.insert('uploaded_image', image.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
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

  Future<int> updateUser(User user) async {
    Database db = await instance.database;
    return await db.update('users', user.toJson(),where: 'id = ?', whereArgs: [user.id]);
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
