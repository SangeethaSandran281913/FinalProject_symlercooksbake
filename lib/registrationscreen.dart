import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'dart:convert';
import 'package:ndialog/ndialog.dart';

import 'package:symlercooksbake/loginscreen.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isChecked = false;
  bool _passwordVisible = true;
  String eula = "";
  bool pwVal = false;

  late double screenHeight, screenWidth, resWidth;
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
      body: Stack(
        children: [upperHalf(context), lowerHalf(context)],
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return SizedBox(
      height: screenHeight,
      width: screenWidth,
      child: Image.asset(
        'assets/images/sp1.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: 600,
      margin: EdgeInsets.only(top: screenHeight / 5),
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 10,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25, 30, 25, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'League Spartan',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          
                          controller: _nameEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Name',
                              hintText: 'No special characters',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.person),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty ||
                                  !val.contains("@") ||
                                  !val.contains(".com")
                              ? "Enter a valid email."
                              : null,
                          focusNode: focus,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus1);
                          },
                          controller: _emailEditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(),
                              labelText: 'Email',
                              icon: Icon(Icons.email),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),

                              TextFormField(
                          textInputAction: TextInputAction.next,
                          
                          controller: _phoneEditingController,
                          keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                          decoration: const InputDecoration(
                              labelText: 'Contact No',
                              hintText: '',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.phone),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),

                      TextFormField(
                        textInputAction: TextInputAction.done,
                        
                        controller: _passEditingController,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(),
                            labelText: 'Password',
                            hintText: 'At least 6 characters',
                            icon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )),
                        obscureText: _passwordVisible,
                      ),

                      Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: FlutterPwValidator(
                                  controller: _passEditingController,
                                  minLength: 8,
                                  uppercaseCharCount: 1,
                                  numericCharCount: 1,
                                  specialCharCount: 1,
                                  width: resWidth / 1.5,
                                  height: screenHeight / 6,
                                  successColor: Colors.lightGreen,
                                  onSuccess: () => {
                                    setState(() {
                                      pwVal == true;
                                    })
                                  },
                                ),
                              ),
                      TextFormField(
                        style: const TextStyle(),
                        textInputAction: TextInputAction.done,
                        validator: (val) {
                          validatePassword(val.toString());
                          if (val != _passEditingController.text) {
                            return "Password do not match!";
                          } else {
                            return null;
                          }
                        },
                        focusNode: focus2,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus3);
                        },
                        controller: _pass2EditingController,
                        decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            hintText: 'Match with Password',
                            labelStyle: const TextStyle(),
                            icon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )),
                        obscureText: _passwordVisible,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: _showEULA,
                              child: const Text('By signing up you agree to our Terms and Condition and Privacy Policy.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.normal,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(screenWidth / 1.5, 50)),
              child: const Text('Register',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              )),
              onPressed: _registerAccountDialog,
           ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                GestureDetector(
                  onTap: () => {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginPage()))
                  },
                  child: const Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
           
          ],
        ),
      ),
    );
  }

  void _registerAccountDialog() {
    String _name = _nameEditingController.text.toString();
    String _email = _emailEditingController.text.toString();
    String _pass = _passEditingController.text.toString();
    String _pass2 = _pass2EditingController.toString();
    String _phone = _phoneEditingController.toString();
    FocusScope.of(context).unfocus();

     if (_name.isEmpty ||
        _email.isEmpty ||
        _pass.isEmpty ||
        _pass2.isEmpty ||
        _phone.isEmpty ) {
      Fluttertoast.showToast(
        msg: "Please do not leave any text fields blank.",
        toastLength: Toast.LENGTH_SHORT,
      );

      return;
     } else if (_phone.length < 10) {
      Fluttertoast.showToast(
        msg: "Invalid phone length",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    else if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the registration form first.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;

    } else if (_name.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>~]'))) {
      Fluttertoast.showToast(
        msg: "Name should not contain special character",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 14.0);
        return;

        } else if (_name.contains(RegExp(r'[0-9]'))) {
      Fluttertoast.showToast(
        msg: "Name should not contain number",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;


    } else if (_pass.length < 6) {
      Fluttertoast.showToast(
        msg: "Your password should be at least 6 characters",
        toastLength: Toast.LENGTH_SHORT,
      );  
      return;
     } else if (_pass.contains(RegExp(r'[a-z]')) == false) {
      Fluttertoast.showToast(
        msg: "Your password should contain at least one lower case",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;

      } else if (_pass.contains(RegExp(r'[A-Z]')) == false) {
      Fluttertoast.showToast(
        msg: "Your password should contain at least one upper case",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;


    } else if (_pass.contains(RegExp(r'[0-9]')) == false) {
      Fluttertoast.showToast(
        msg: "Your password should contain at least one number",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    } else if (_pass.contains(RegExp(r'[ ]'))) {
      Fluttertoast.showToast(
        msg: "Your password should not contain space",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;

    } else if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please accept the terms and conditions",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    } 

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
          content: const Text(
            "Are you sure?",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                _registerUserAccount();
                Get.off(() => const LoginPage());
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String? validatePassword(String value) {
    // String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password.';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password.';
      } else {
        return null;
      }
    }
  }

  void _showEULA() {
    loadEula();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
          ),
          content: SizedBox(
            height: screenHeight / 1.5,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                        text: eula),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  loadEula() async {
    eula = await rootBundle.loadString('assets/eula.txt');
  }

  void _registerUserAccount() {
    FocusScope.of(context).requestFocus(FocusNode());
    String _name = _nameEditingController.text;
    String _email = _emailEditingController.text;
    String _pass = _passEditingController.text;
    String _phone = _phoneEditingController.text;
    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Registration in progress.."),
        title: const Text("Registering..."));
    progressDialog.show();

    http.post(Uri.parse("https://symlercooksbake.000webhostapp.com/directory/php/register_user.php"),
        body: {
          "name": _name,
          "email": _email,
          "password": _pass,
          "phone": _phone
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Registration Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Registration Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      }
    });
  }
}
