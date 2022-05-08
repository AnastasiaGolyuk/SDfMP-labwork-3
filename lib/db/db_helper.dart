import 'dart:async';
import 'dart:io';

import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/models/mood.dart';
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
    String path = join(documentsDirectory.path, 'draft4.db');
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

    await db.execute('''
      CREATE TABLE moods(
          id INTEGER PRIMARY KEY,
          idUser INTEGER,
          mood TEXT,
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
    return await db.insert('uploaded_image', image.toJson());
  }



  Future<List<Mood>> getMoods(int idUser) async {
    Database db = await instance.database;
    var results = await db.query('moods',where: 'idUser = ?', whereArgs: [idUser]);
    List<Mood> moodsList = results.isNotEmpty
        ? results.map((c) => Mood.fromJson(c)).toList()
        : [];
    return moodsList;
  }

  Future<int> getMoodsCount() async {
    Database db = await instance.database;
    var results = await db.query('moods');
    List<Mood> moodsList = results.isNotEmpty
        ? results.map((c) => Mood.fromJson(c)).toList()
        : [];
    return moodsList.length;
  }

  Future<int> addMood(Mood mood) async {
    Database db = await instance.database;
    return await db.insert('moods', mood.toJson());
  }

  Future<Mood?> getRecentMood(int idUser) async {
    var moods = await getMoods(idUser);
    if (moods.isEmpty){
      return null;
    }
    var diffDates = <int>[];
    int min = 1000;
    int index=0;
    int i = 0;
    for (Mood mood in moods){
      var diff = DateTime.now().difference(DateTime.parse(mood.timeUpload)).inDays;
      diffDates.add(diff);
      if (diff<=min){
        min=diff;
        index=i;
      }
      i++;
    }
    return moods[index];
  }

  Future<Mood?> getCommonMood(int idUser) async {
    var moods = await getMoods(idUser);
    if (moods.isEmpty){
      return null;
    }
    var countMoods = List.filled(Consts.titles.length, 0);
    int max = 0;
    int index=0;
    int iDB = 0;
    for (int a=0;a<Consts.titles.length;a++){
      String mood = Consts.titles.elementAt(a);
      for (iDB=0;iDB<moods.length;iDB++) {
        if (moods[iDB].mood == mood) {
          countMoods[a]++;
        }
      }
    }

    for(int i=0;i<countMoods.length;i++){
      if (countMoods[i]>max){
        max=countMoods[i];
        index=i;
      }
    }
    return moods[index];
  }

  Future<User?> findAuthUser() async {
    var results = await getUsers();
    User? user;
    for (var element in results) {
      print("id ${element.id} ${element.username}  auth ${element.isAuthorized}");
      if (element.isAuthorized==1){
        user=element;
        return user;
      }
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    Database db = await instance.database;
    return await db.update('users', user.toJson(), where: 'id = ?', whereArgs: [user.id]);
  }


  Future<int> getUsersCount() async {
    var results = await getUsers();
    return results.length;
  }

  Future<int> addUser(User user) async {
    Database db = await instance.database;
    return await db.insert('users', user.toJson());
  }

  Future<User?> findUser(String email) async {
    var results = await getUsers();
    User? user;
    for (var element in results) {
      if (element.email==email){
        user=element;
        return user;
      }
    }
    return null;
  }
}
