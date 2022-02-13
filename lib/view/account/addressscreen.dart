import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:symlercooksbake/model/address.dart';
import 'package:symlercooksbake/model/user.dart';
import 'package:ndialog/ndialog.dart';
import 'package:symlercooksbake/view/account/addaddressscreen.dart';
import 'package:symlercooksbake/widget/loading.dart';

class AddressScreen extends StatefulWidget {
  final User user;
  final email;
  final bool chooseAddress;

  const AddressScreen({
    Key? key,
    required this.user,
    required this.chooseAddress,
    required this.email
  }) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String _titlecenter = "";
  List _addressList = [];
  late Address address;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('Address',
            style:  GoogleFonts.pacifico(fontSize: 32, color: Colors.white,
                fontWeight: FontWeight.normal )),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _addAddress();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            if (_addressList.isEmpty)
              Flexible(
                  child: Center(
                child: _titlecenter == ""
                    ? const Loading()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/addressnull.png",
                            height: 150,
                            width: 150,
                          ),
                          const SizedBox(height: 10),
                          const Text('Address Is Empty!',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 20),
                        ],
                      ),
              ))
            else
              Flexible(
                  child: Container(
                decoration: const BoxDecoration(),
                child: GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 2 / 1,
                    children: List.generate(_addressList.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          if (widget.chooseAddress == false) {
                            return;
                          } else {
                            _chooseAddress(index);
                          }
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Card(
                                child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 9,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                                _addressList[index]['name'],
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              _addressList[index]['phone'],
                                              style: const TextStyle(
                                                height: 1.5,
                                                fontSize: 15,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 5,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              titleSub(_addressList[index]
                                                  ['address']),
                                              style: const TextStyle(
                                                height: 1.5,
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            _deleteAddressDialog(index);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                      );
                    })),
              )),
          ],
        ),
      ),
    );
  }

  String titleSub(String title) {
    if (title.length > 120) {
      return title.substring(0, 120) + "...";
    } else {
      return title;
    }
  }

  _loadAddress() {
    http.post(
        Uri.parse(
            "https://symlercooksbake.000webhostapp.com/directory/php/load_address.php"),
        body: {"email": widget.user.email}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "No Address";
        _addressList = [];
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        _addressList = jsondata["address"];
      }
      setState(() {});
    });
  }

  Future<void> _deleteAddress(int index) async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Delete address"), title: const Text("Progress..."));
    progressDialog.show();
    await Future.delayed(const Duration(seconds: 1));
    http.post(
        Uri.parse(
            "https://symlercooksbake.000webhostapp.com/directory/php/delete_address.php"),
        body: {
          "email": widget.user.email,
          "name": _addressList[index]['name'],
          "address": _addressList[index]['address'],
          "phone": _addressList[index]['phone'],
        }).then((response) {
      if (response.body == "Success") {
        Fluttertoast.showToast(
            msg: "Success", toastLength: Toast.LENGTH_SHORT, fontSize: 16.0);
        _loadAddress();
      } else {
        Fluttertoast.showToast(
            msg: "Failed", toastLength: Toast.LENGTH_SHORT, fontSize: 16.0);
      }
      progressDialog.dismiss();
    });
  }

  void _deleteAddressDialog(int index) {
    showDialog(
        builder: (context) => AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: const Text(
                  'Delete your address?',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Yes"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _deleteAddress(index);
                    },
                  ),
                  TextButton(
                      child: const Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ]),
        context: context);
  }



  void _chooseAddress(index) {
    address = Address(index);
    Navigator.pop(context, address);
  }

  void _addAddress() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              'Do you want to add new address?',
              style: TextStyle(),
            ),
            content: const Text(
              'Are your sure?',
              style: TextStyle(),
            ),
            actions: <Widget>[
              MaterialButton(
                   onPressed:
                    () {
                    Navigator.pop(context);
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (content) =>
                                    AddAddressScreen(email : widget.user.email)))
                        .then((_) => setState(() {
                              _loadAddress();
                            }));
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
}
