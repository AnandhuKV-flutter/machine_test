import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocationService {
  final Location _location = Location();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LocationService() {
    _location.requestPermission().then((granted) {
      if (granted != null && granted != PermissionStatus.granted) {
        print('Location permission not granted');
      }
    });

    _location.enableBackgroundMode(enable: true);
    _location.changeSettings(interval: 1800000); // 30 minutes

    _location.onLocationChanged.listen((locationData) {
      if (_auth.currentUser != null) {
        _db.collection('locations').add({
          'user_id': _auth.currentUser!.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'latitude': locationData.latitude,
          'longitude': locationData.longitude,
        });
      }
    });
  }
}
