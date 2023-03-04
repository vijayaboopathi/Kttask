// ignore_for_file: use_build_context_synchronously
import '../controller/db_controller.dart';
import 'package:flutter/material.dart';
import 'package:kttask/views/login_page.dart';
import 'package:kttask/views/users.dart';
import '../utils/database_helper.dart';
import '../widgets/input_field.dart';
import '../utils/dialogue_helper.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<Signup> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUp"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const User()),
                );
              },
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: formKey,
                child: Column(
                  children: [
                    inputField(
                        "UserName", "Enter UserName", Icons.person, _userName),
                    inputField("Password", "Enter Password", Icons.password,
                        _password),
                    Container(
                      height: 50,
                      width: double.infinity,
                      margin:
                          const EdgeInsets.only(left: 30, right: 30, top: 15),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                          onPressed: () async {
                            String username = _userName.text.toString();
                            String password = _password.text.toString();
                            final data =
                                await SQLHelper.getUser(username, password);
                            if (username == '' || password == '') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(Dialogue().emptyBar);
                            } else if (data.isNotEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(Dialogue().exitsBar);
                            } else {
                              DbCtr().signup(username, password);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(Dialogue().successBar);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            }
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          )),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
