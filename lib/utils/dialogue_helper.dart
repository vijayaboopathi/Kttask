import 'package:flutter/material.dart';

class Dialogue {
  final emptyBar = const SnackBar(content: Text("Enter Username and Password"));
  final successBar = const SnackBar(content: Text("User Created Successfully"));
  final exitsBar = const SnackBar(content: Text("UserName already in use"));
  final errorBar = const SnackBar(content: Text("Username or Password is wrong"));
}