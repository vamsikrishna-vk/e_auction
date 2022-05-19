import 'package:flutter/material.dart';
import 'signup.dart';
import 'package:provider/provider.dart';
import 'authentication_service.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String _status = 'no-action';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Container(
            padding: EdgeInsets.all(20.0),
            //color: Colors.white,
            height: 367,
            width: 356,
            child: Column(
              children: <Widget>[
                SizedBox(height: 22.0),
                Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0,
                  ),
                ),
                SizedBox(height: 22.0),
                SizedBox(
                    height: 50.0,
                    child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'UserID',
                          filled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                        ))),
                SizedBox(height: 22.0),
                SizedBox(
                  height: 50.0,
                  child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Password',
                        filled: true,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 8.0),
                      )),
                ),
                SizedBox(height: 22.0),
                RaisedButton(
                  onPressed: () {
                    context.read<AuthenticationService>().signIn(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                  },
                  child: Text('Login'),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () => {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => signup()))
                  },
                  child: Text("New User? Signup"),
                )
              ],
            )),
      ),
    );
  }
}
