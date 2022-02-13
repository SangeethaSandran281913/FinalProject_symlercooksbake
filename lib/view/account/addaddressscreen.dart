import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:symlercooksbake/view/account/mapscreen.dart';
import 'package:ndialog/ndialog.dart';
import 'package:symlercooksbake/model/delivery.dart';


class AddAddressScreen extends StatefulWidget {
  final email;
  const AddAddressScreen({Key? key, this.email}) : super(key: key);
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController =  TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String address = "";
  @override
  Widget build(BuildContext context) {
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
                        "Add New Address",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      buildTextField("Name", "Name", "name"),
                      buildTextField("Contact", "Contact Number", "contact"),
                      TextField(
                        enabled: false,
                        controller: _addressController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          labelText: "Address",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(),
                          hintText: 'Search/Enter address',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        minLines: 4,
                        maxLines: 4,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                              ),
                              onPressed: () async {
                                Delivery _del =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const MapScreen(),
                                  ),
                                );
                                setState(() {
                                  
                                  _del == null
                                      ? _addressController.text =
                                          "No location selected."
                                      : _addressController.text = _del.address;
                                });
                              },
                              child: const Text("Map"),
                            ),
                          ),
                          Container(
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                              ),
                              onPressed: () => {_getUserCurrentLoc()},
                              child: const Text(" My Location"),
                            ),
                          ),
                        ],
                      ),
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
                          _updateaddress();
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
    if (textField == "contact") {
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
          controller: _nameController,
        ),
      );
    }
  }

  _updateaddress() {
    FocusScope.of(context).unfocus();
    String _name = _nameController.text.toString();
    String _contact = _contactController.text.toString();
    String _address = _addressController.text.toString();

    if (_name.isEmpty || _contact.isEmpty || _address.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please do not leave any text fields blank.",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }
    if (_name.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>~]'))) {
      Fluttertoast.showToast(
        msg: "Full name should not contain special character",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    } else if (_name.contains(RegExp(r'[0-9]'))) {
      Fluttertoast.showToast(
        msg: "Full name should not contain number",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    } else if ((_contact.length < 10 || _contact.length > 13) &&
        _contact != "") {
      Fluttertoast.showToast(
        msg: "Invalid phone length",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    } else {
      http.post(
          Uri.parse(
              "https://symlercooksbake.000webhostapp.com/directory/php/add_address.php"),
          body: {
            "email": widget.email,
            "name": _name.toUpperCase(),
            "address": _address.toUpperCase(),
            "phone": _contact,
          }).then((response) {
        if (response.body == "Success") {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Success.", toastLength: Toast.LENGTH_SHORT, fontSize: 16.0);
          setState(() {});
          return;
        } else if (response.body == "Already Exist") {
          Fluttertoast.showToast(
              msg: "Already Exist.",
              toastLength: Toast.LENGTH_SHORT,
              fontSize: 16.0);
          setState(() {});
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

  _getUserCurrentLoc() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Searching address"), title: const Text("Locating..."));
    progressDialog.show();
    await _determinePosition().then((value) => {_getPlace(value)});
    setState(
      () {},
    );
    progressDialog.dismiss();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _getPlace(Position pos) async {
    MarkerId markerId1 = const MarkerId("12");
    List<Placemark> newPlace =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    Set<Marker> markers = Set();
    Placemark placeMark = newPlace[0];
    String name = placeMark.name.toString();
    String subLocality = placeMark.subLocality.toString();
    String locality = placeMark.locality.toString();
    String administrativeArea = placeMark.administrativeArea.toString();
    String postalCode = placeMark.postalCode.toString();
    String country = placeMark.country.toString();
    address = name +
        ", " +
        subLocality +
        ", " +
        locality +
        ", " +
        postalCode +
        ", " +
        administrativeArea +
        ", " +
        country;

    String _address = "No location selected";
    markers.clear();
    markers.add(Marker(
      markerId: markerId1,
      position: LatLng(pos.latitude, pos.longitude),
      infoWindow: InfoWindow(
        title: 'Address',
        snippet: _address,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ));
    double dis = calculateDistance(pos.latitude, pos.longitude);
    if (dis > 40) {
      Fluttertoast.showToast(
        msg: "Current Delivery Distance is " +
            dis.toStringAsFixed(2) +
            " KM. \nMaximum Delivery Distance is 40 KM. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
      );
      _addressController.text = "No location selected.";
      return;
    } else {
      _addressController.text = address;
    }
  }

  double calculateDistance(lat1, lon1) {
    var lat2 = 5.32146;
    var lon2 = 100.45399;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
