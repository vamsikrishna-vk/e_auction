import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'authentication_service.dart';

class signup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _signupState();
  }
}

class _signupState extends State<signup> {
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
                  "Sign Up",
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
                    context.read<AuthenticationService>().signUp(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        context: context);
                  },
                  child: Text('Sign Up'),
                ),
              ],
            )),
      ),
    );
  }
}
