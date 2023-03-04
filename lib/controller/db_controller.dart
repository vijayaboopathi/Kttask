import 'package:kttask/utils/database_helper.dart';

class DbCtr {
  Future<void> signup(String username, String password) async {
    await SQLHelper.createUser(username, password);
  }
}