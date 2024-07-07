import 'package:flutter/material.dart';

import '../../data/services/location_services.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getLocationDataForAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final data = snapshot.data;
            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('User: ${data[index]['userId']}'),
                  subtitle: Text('Location: ${data[index]['latitude']}, ${data[index]['longitude']} at ${data[index]['timestamp']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
