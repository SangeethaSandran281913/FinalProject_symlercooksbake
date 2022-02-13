
// ignore: unused_import
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:symlercooksbake/model/user.dart';
import 'package:symlercooksbake/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:symlercooksbake/view/account/addressscreen.dart';
import 'package:symlercooksbake/view/account/editprofilescreen.dart';
import 'package:symlercooksbake/view/account/historyscreen.dart';
import 'package:symlercooksbake/widget/orderbutton.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class TabPage3 extends StatefulWidget {
  final User user;
  const TabPage3({Key? key, required this.user}) : super(key: key);

  @override
  _TabPage3State createState() => _TabPage3State();
}

class _TabPage3State extends State<TabPage3> {
  late double screenHeight, screenWidth, resWidth;
  final TextEditingController _curpasswordController = TextEditingController();
  final TextEditingController _rpasswordController = TextEditingController();
  final TextEditingController _conpasswordController =  TextEditingController();



  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
     
    if (screenWidth <= 600) {
      resWidth = screenWidth * 0.85;
    } else {
      resWidth = screenWidth * 0.75;
    }
 
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.5,
        backgroundColor: Colors.black,
        title:  Text('Symler Cooks & Bake',
            style:  GoogleFonts.pacifico(fontSize: 31, color: Colors.white,
                fontWeight: FontWeight.normal )),
        
        
      ),
      
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(
                      left: 20.0, right: 0.0, top: 20.0, bottom: 10.0),
                  child: Text("Account",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                ),
              ],
            ),
            Card(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(children: <Widget>[
                    ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text("Edit Profile"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          _editProfile(widget.user);
                        }),
                    ListTile(
                        leading: const Icon(Icons.lock),
                        title: const Text("Change password"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          _changePassword();
                          
                        }),
                    ListTile(
                        leading: const Icon(Icons.location_on),
                        title: const Text("My Address"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => AddressScreen(
                                          user: widget.user,
                                          chooseAddress: false, email: widget.user)))
                              .then((_) => setState(() {}));
                        }),
                    ListTile(
                        leading: const Icon(Icons.history),
                        title: const Text("Purchase History"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (content) => HistoryScreen(
                                        user: widget.user,
                                      ))).then((_) => setState(() {}));
                        }),
                  ])),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(children: <Widget>[
                    ListTile(
                        leading: const Text(""),
                        title: const Text("Log Out"),
                        trailing: const Icon(Icons.logout, color: Colors.red),
                        onTap: () {
                          _logOut();
                        }),
                  ])),
            ),
          ],
        ),
        
      ),
       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
       floatingActionButton: FloatingActionButton(
         child: const Icon(Icons.phone_android),
        backgroundColor: Colors.green,
     
         onPressed: () { _makingPhoneCall(); },
      ),
      
       
      
    );
    
  }
  void _editProfile(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              'Do you want to edit profile?',
              style: TextStyle(),
            ),
            content: const Text(
              'Are your sure?',
              style: TextStyle(),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) =>
                                EditProfileScreen(user: user)));
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(),
                  )),
            ],
        );
      },
    );
  }

  void _changePassword() {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              'Do you want to change password?',
              style: TextStyle(),
            ),
            content: const Text(
              'Are your sure?',
              style: TextStyle(),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _resetPassword();
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(),
                  )),
            ],
        );
      },
    );
}

void _resetPassword() {
  
    _curpasswordController.clear();
    _rpasswordController.clear();
    _conpasswordController.clear();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Change Pasword"),
              content: SizedBox(
                height: 200,
                width: 175,
                
                child: Column(
                  children: [
                    TextFormField(
                      controller: _curpasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Current Password',
                      ),
                    ),
                    TextFormField(
                      controller: _rpasswordController,
                      decoration: const InputDecoration(
                        labelText: 'New Password',
                      ),
                    ),
                    TextFormField(
                      controller: _conpasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Submit"),
                  onPressed: () {
                    if (_curpasswordController.text.isEmpty ||
                        _rpasswordController.text.isEmpty ||
                        _conpasswordController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Please do not leave any text fields blank.",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                      return;
                    } else if (_rpasswordController.text !=
                        _conpasswordController.text) {
                      Fluttertoast.showToast(
                        msg:
                            "Your Passwords and Confirm Password do not match.",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                      return;
                    } else if (_rpasswordController.text.toString().length <
                        6) {
                      Fluttertoast.showToast(
                        msg: "Your password should be at least 6 characters",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                      return;
                    } else if (_rpasswordController.text
                            .toString()
                            .contains(RegExp(r'[a-z]')) ==
                        false) {
                      Fluttertoast.showToast(
                        msg:
                            "Your password should contain at least one lower case",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                      return;
                    } else if (_rpasswordController.text
                            .toString()
                            .contains(RegExp(r'[0-9]')) ==
                        false) {
                      Fluttertoast.showToast(
                        msg: "Your password should contain at least one number",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                      return;
                    } else if (_rpasswordController.text
                        .toString()
                        .contains(RegExp(r'[ ]'))) {
                      Fluttertoast.showToast(
                        msg: "Your password should not contain space",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                      return;
                    }
                    http.post(
                        Uri.parse(
                             "https://symlercooksbake.000webhostapp.com/directory/php/reset_password.php"),
                        body: {
                          "email": widget.user.email,
                          "npassword": _rpasswordController.text.toString(),
                          "curpassword": _curpasswordController.text.toString(),
                          "status": "update",
                        }).then((response) {
                      if (response.body == "Update Success") {
                        Fluttertoast.showToast(
                          msg: "Update Success",
                          toastLength: Toast.LENGTH_SHORT,
                        );
                        Navigator.pop(context);
                      } else {
                        Fluttertoast.showToast(
                          msg: "Update Failed",
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      }
                    });
                  },
                ),
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        });

        
}

  void _logOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Are you sure you would like to log out?",
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
         
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const LoginPage()));
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

 _makingPhoneCall() async {
  const url = 'tel:0169052425';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

}

