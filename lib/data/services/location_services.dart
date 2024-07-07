import 'package:location/location.dart';
import 'package:workmanager/workmanager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

class LocationService {
  Location location = new Location();

  Future<void> requestPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<LocationData> getLocation() async {
    return await location.getLocation();
  }

  Future<void> trackLocationInBackground() async {
    LocationData locationData = await getLocation();
    DatabaseHelper dbHelper = DatabaseHelper();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      dbHelper.insertLocationData(user.uid, locationData.latitude!, locationData.longitude!);
    }
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'location.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE LocationData (
            id INTEGER PRIMARY KEY,
            userId TEXT,
            timestamp TEXT,
            latitude REAL,
            longitude REAL
          )
        ''');
      },
    );
  }

  Future<void> insertLocationData(String userId, double latitude, double longitude) async {
    final db = await database;
    await db.insert(
      'LocationData',
      {
        'userId': userId,
        'timestamp': DateTime.now().toIso8601String(),
        'latitude': latitude,
        'longitude': longitude,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getLocationData(String userId) async {
    final db = await database;
    return await db.query(
      'LocationData',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<List<Map<String, dynamic>>> getLocationDataForAllUsers() async {
    final db = await database;
    return await db.query('LocationData');
  }
}
