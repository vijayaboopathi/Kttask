import 'package:flutter/material.dart';

import '../utils/database_helper.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  UserState createState() => UserState();
}

class UserState extends State<User> {
  List<Map<String, dynamic>> user = [];
  bool _isLoading = true;
  void _refreshUser() async {
    final data = await SQLHelper.getUsers();
    setState(() {
      user = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshUser(); // Loading the diary when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: user.length,
              itemBuilder: (context, index) => Card(
                color: Colors.orange[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text(" Username :" + user[index]["username"]),
                  subtitle: Text('Password :' + user[index]["password"]),
                ),
              ),
            ),
    );
  }
}
