import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:symlercooksbake/model/user.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _fullnameController =  TextEditingController();
  final TextEditingController _contactController = TextEditingController();
   late double screenHeight, screenWidth, resWidth;
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
 
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Center(
            child: Column(
              children: [
                Flexible(
                  child: ListView(
                    children: [
                      const Text(
                        "Edit Profile",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      buildTextField(
                          "Name", widget.user.name.toString(), "name"),
                      buildTextField("E-mail", widget.user.email.toString(), "email"), 
                      buildTextField("Phone", widget.user.phone.toString(), "phone"),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ignore: deprecated_member_use
                      RaisedButton(
                        onPressed: () {
                          _updateprofile();
                        },
                        color: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text(
                          "SAVE",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, String textField) {
    if (textField == "name") {
      return Padding(
        padding: const EdgeInsets.only(bottom: 35.0),
        child: TextField(
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(bottom: 3),
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeholder,
              hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              )),
          controller: _fullnameController,
        ),
      );
    } else if (textField == "phone") {
      return Padding(
        padding: const EdgeInsets.only(bottom: 35.0),
        child: TextField(
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(bottom: 3),
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeholder,
              hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              )),
          controller: _contactController,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 35.0),
        child: TextField(
          enabled: false,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(bottom: 3),
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeholder,
              hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              )),
        ),
      );
    }
  }



  _updateprofile() {
    String _fullname = _fullnameController.text.toString();
    String _contact = _contactController.text.toString();

    if (_fullname.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>~]'))) {
      Fluttertoast.showToast(
        msg: "Full name should not contain special character",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    } else if (_fullname.contains(RegExp(r'[0-9]'))) {
      Fluttertoast.showToast(
        msg: "Full name should not contain number",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    } else if ((_contact.length < 10) &&
        _contact != "") {
      Fluttertoast.showToast(
        msg: "Invalid phone length",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    } else {
      if (_contact == "" &&
          _fullname != "") //fullname change and contact unchange
      {
        http.post(
            Uri.parse(
                "https://symlercooksbake.000webhostapp.com/directory/php/update_profile.php"),
            body: {
              "email": widget.user.email,
              "name": _fullname.toUpperCase(),
              "phone": widget.user.phone.toString(),
              
            }).then((response) {
          if (response.body == "Success") {
            FocusScope.of(context).unfocus();
            Fluttertoast.showToast(
                msg: "Success.",
                toastLength: Toast.LENGTH_SHORT,
                fontSize: 16.0);
            setState(() {
              widget.user.name = _fullname.toUpperCase();
            });
            return;
          } else {
            Fluttertoast.showToast(
                msg: "Please Try Again.",
                toastLength: Toast.LENGTH_SHORT,
                fontSize: 16.0);
            setState(() {});
          }
        });
      } else if (_fullname == "" &&
          _contact != "") //fullname unchange and contact change
      {
        http.post(
            Uri.parse(
                "https://symlercooksbake.000webhostapp.com/directory/php/update_profile.php"),
            body: {
              "email": widget.user.email,
              "name": widget.user.name,
              "phone": _contact,
              
            }).then((response) {
          if (response.body == "Success") {
            FocusScope.of(context).unfocus();
            Fluttertoast.showToast(
                msg: "Success.",
                toastLength: Toast.LENGTH_SHORT,
                fontSize: 16.0);
            setState(() {
              widget.user.phone = _contact;
            });
            return;
          } else {
            Fluttertoast.showToast(
                msg: "Please Try Again.",
                toastLength: Toast.LENGTH_SHORT,
                fontSize: 16.0);
            setState(() {});
          }
        });
      } else if (_contact != "" &&
          _fullname != "") //contact and fullname change
      {
        http.post(
            Uri.parse(
                "https://symlercooksbake.000webhostapp.com/directory/php/update_profile.php"),
            body: {
              "email": widget.user.email,
              "fullname": _fullname.toUpperCase(),
              "phone": _contact,
              
            }).then((response) {
          if (response.body == "Success") {
            FocusScope.of(context).unfocus();
            Fluttertoast.showToast(
                msg: "Success.",
                toastLength: Toast.LENGTH_SHORT,
                fontSize: 16.0);
            setState(() {
              widget.user.phone = _contact;
              widget.user.name = _fullname.toUpperCase();
            });
            return;
          } else {
            Fluttertoast.showToast(
                msg: "Please Try Again.",
                toastLength: Toast.LENGTH_SHORT,
                fontSize: 16.0);
            setState(() {});
          }
        });
        return;
      } else {
        http.post(
            Uri.parse(
                "https://symlercooksbake.000webhostapp.com/directory/php/update_profile.php"),
            body: {
              "email": widget.user.email,
              "fullname": widget.user.name,
              "phone": widget.user.phone,
              
            }).then((response) {
          if (response.body == "Success") {
            FocusScope.of(context).unfocus();
            Fluttertoast.showToast(
                msg: "Success.",
                toastLength: Toast.LENGTH_SHORT,
                fontSize: 16.0);
            setState(() {});
            return;
          } else {
            Fluttertoast.showToast(
                msg: "Please Try Again.",
                toastLength: Toast.LENGTH_SHORT,
                fontSize: 16.0);
            setState(() {});
          }
        });
      }
    }
  }
}
