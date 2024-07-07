import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin_service.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adminService = Provider.of<AdminService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: StreamBuilder(
        stream: adminService.getAllUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return ListTile(
                title: Text(user['email']),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => UserLocationsScreen(userId: user.id),
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }
}

class UserLocationsScreen extends StatelessWidget {
  final String userId;

  UserLocationsScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    final adminService = Provider.of<AdminService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('User Locations')),
      body: StreamBuilder(
        stream: adminService.getUserLocations(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var locations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              var location = locations[index];
              return ListTile(
                title: Text('Lat: ${location['latitude']}, Long: ${location['longitude']}'),
                subtitle: Text(location['timestamp'].toDate().toString()),
              );
            },
          );
        },
      ),
    );
  }
}
