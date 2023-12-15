import 'dart:convert';

import 'package:blended_learning_app_new/homePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPassword = true;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  var _emailMessageErr = "";
  var _passwordMessageErr = "";
  bool _emailInvalid = false;
  bool _passwordInvalid = false;
  void loginSuccess(String email, password) async {
    try {
      var response = await http
          .post(Uri.parse('http://localhost:3001/v1/auth/login'), body: {
        'email': email,
        'password': password,
      });
      print(response);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data['token']);
        print('Login successfully');
      } else {
        print('failed');
        setState(() {
          _emailInvalid = true;
          _passwordInvalid = true;
          _emailMessageErr = "Email không đúng";
          _passwordMessageErr = "Mật khẩu không đúng";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo.webp'),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: Text(
                "Đăng nhập",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: TextField(
                style: TextStyle(color: Colors.black, fontSize: 18),
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: "Email",
                    errorText: _emailInvalid ? _emailMessageErr : null,
                    labelStyle:
                        TextStyle(color: Color(0xff888888), fontSize: 15)),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: TextField(
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        controller: _passwordController,
                        obscureText: _showPassword,
                        decoration: InputDecoration(
                            labelText: "Password",
                            errorText:
                                _passwordInvalid ? _passwordMessageErr : null,
                            labelStyle: TextStyle(
                                color: Color(0xff888888), fontSize: 15)),
                      ),
                    ),
                    GestureDetector(
                      onTap: onIconShowPassword,
                      child: Icon(
                          _showPassword
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          color: Color(0xff888888),
                          weight: 14),
                    )
                  ]),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                    shape: MaterialStatePropertyAll<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  onPressed: onSignInClicked,
                  child: Text(
                    "Đăng nhập",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "Quên mật khẩu?",
              style: TextStyle(fontSize: 16, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }

  void onIconShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void onSignInClicked() async {
    setState(() {
      if (_emailController.text.length == 0) {
        _emailInvalid = true;
        _emailMessageErr = "Email không hợp lệ";
      } else if (!_emailController.text.contains("@")) {
        _emailInvalid = true;
        _emailMessageErr = "Email phải chứa ký tự @";
      }
      if (_passwordController.text.length == 0) {
        _passwordInvalid = true;
        _passwordMessageErr = "Mật khẩu không hợp lệ";
      }
    });
    String email = _emailController.text.toString();
    String password = _passwordController.text.toString();
    loginSuccess(email, password);
    if (!_emailInvalid && !_passwordInvalid) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
    print(_emailInvalid);
    print(_passwordInvalid);
  }
}
