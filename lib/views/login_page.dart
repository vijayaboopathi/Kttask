import 'package:flutter/material.dart';
import 'package:kttask/views/home_page.dart';
import 'package:kttask/views/signup_page.dart';
import '../utils/database_helper.dart';
import '../widgets/input_field.dart';
import '../utils/dialogue_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  int index = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KTT Task"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            inputField("UserName", "Enter UserName", Icons.person, _userName),
            inputField("Password", "Enter Password", Icons.password, _password),
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 30, right: 30, top: 15),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  onPressed: () async {
                    String name = _userName.text.toString();
                    String pass = _password.text.toString();
                    final data = await SQLHelper.getUser(name, pass);
                    if (name == '' || pass == '') {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(Dialogue().emptyBar);
                    } else if (data.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(Dialogue().errorBar);
                    } else if (name == data[index]["username"] &&
                        pass == data[index]["password"]) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  user: name,
                                )),
                      );
                    }
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Do not have account",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(35, 61, 77, 1)),
                ),
                TextButton(
                    child: const Text("SingUp",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Signup()),
                      );
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
