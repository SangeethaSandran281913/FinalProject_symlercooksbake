import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:symlercooksbake/view/checkout/checkoutscreen.dart';
import 'package:symlercooksbake/widget/loading.dart';
import 'package:symlercooksbake/model/user.dart';

class CartScreen extends StatefulWidget {
  final User user;

  const CartScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _titlecenter = "";
  List _cartList = [];
  double _totalprice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadMyCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.5,
        backgroundColor: Colors.black,
        title:  Text('My Cart',
            style:  GoogleFonts.pacifico(fontSize: 31, color: Colors.white,
                fontWeight: FontWeight.normal )),
        
      ),
      body: Center(
        child: Column(
          children: [
            if (_cartList.isEmpty)
              Flexible(
                  child: Center(
                child: _titlecenter == ""
                    ? const Loading()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/emptycart.png",
                            height: 150,
                            width: 150,
                          ),
                          const SizedBox(height: 10),
                          const Text('Cart Is Empty!',
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
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 2.5 / 1,
                    children: List.generate(_cartList.length, (index) {
                      return Padding(
                          padding: const EdgeInsets.all(3),
                          child: Card(
                              child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Colors.pinkAccent,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CachedNetworkImage(
                                          imageUrl:
                                              "https://symlercooksbake.000webhostapp.com/directory/images/${_cartList[index]['prid']}_1.jpg",
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover),
                                    ],
                                  )),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                              _cartList[index]['prname'],
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          "RM " +
                                              (int.parse(_cartList[index]
                                                          ['cartqty']) *
                                                      double.parse(_cartList[
                                                              index]
                                                          ['prprice']))
                                                  .toStringAsFixed(2),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                  ),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                child: SizedBox(
                                                    height: 30.0,
                                                    width: 20.0,
                                                    child: IconButton(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      icon: const Icon(
                                                          Icons.remove,
                                                          size: 20),
                                                      onPressed: () {
                                                        _modQty(index,
                                                            "removecart");
                                                      },
                                                    ))),
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                child: SizedBox(
                                                  height: 30.0,
                                                  width: 100.0,
                                                  child: Center(
                                                    child: Text(_cartList[index]
                                                        ['cartqty']),
                                                  ),
                                                )),
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10),
                                                  ),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                child: SizedBox(
                                                    height: 30.0,
                                                    width: 20.0,
                                                    child: IconButton(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      icon: const Icon(Icons.add,
                                                          size: 20),
                                                      onPressed: () {
                                                        _modQty(
                                                            index, "addcart");
                                                      },
                                                    ))),
                                          ],
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
                                          _deleteCartDialog(index);
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )));
                    })),
              )),
            Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "TOTAL",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      "RM " + _totalprice.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent),
                    ),
                    // SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _payDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      child: const Text("CHECKOUT"),
                      
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  _loadMyCart() {
    http.post(
        Uri.parse(
            "https://symlercooksbake.000webhostapp.com/directory/php/load_cart.php"),
        body: {"email": widget.user.email}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "No item";
        _cartList = [];
        _totalprice = 0.0;
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        _cartList = jsondata["cart"];
        _totalprice = 0.0;
        for (int i = 0; i < _cartList.length; i++) {
          _totalprice = _totalprice +
              double.parse(_cartList[i]['prprice']) *
                  int.parse(_cartList[i]['cartqty']);
        }
      }
      setState(() {});
    });
  }

  Future<void> _modQty(int index, String s) async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Update cart"), title: const Text("Progress..."));
    progressDialog.show();
    await Future.delayed(const Duration(seconds: 1));
    http.post(
        Uri.parse(
            "https://symlercooksbake.000webhostapp.com/directory/php/update_cart.php"),
        body: {
          "email": widget.user.email,
          "op": s,
          "prid": _cartList[index]['prid'],
          "qty": _cartList[index]['cartqty']
        }).then((response) {
      if (response.body == "Success") {
        Fluttertoast.showToast(
            msg: "Success", toastLength: Toast.LENGTH_SHORT, fontSize: 16.0);
        _loadMyCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed", toastLength: Toast.LENGTH_SHORT, fontSize: 16.0);
      }
      progressDialog.dismiss();
    });
  }

  Future<void> _deleteCart(int index) async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Delete from cart"), title: const Text("Progress..."));
    progressDialog.show();
    await Future.delayed(const Duration(seconds: 1));
    http.post(
        Uri.parse(
            "https://symlercooksbake.000webhostapp.com/directory/php/delete_cart.php"),
        body: {
          "email": widget.user.email,
          "prid": _cartList[index]['prid']
        }).then((response) {
      if (response.body == "Success") {
        Fluttertoast.showToast(
            msg: "Success", toastLength: Toast.LENGTH_SHORT, fontSize: 16.0);
        _loadMyCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed", toastLength: Toast.LENGTH_SHORT, fontSize: 16.0);
      }
      progressDialog.dismiss();
    });
  }

  void _deleteCartDialog(int index) {
    showDialog(
        builder: (context) => AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: const Text(
                  'Delete from your cart?',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Yes"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _deleteCart(index);
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

  void _payDialog() {
    if (_totalprice == 0.0) {
      Fluttertoast.showToast(
          msg: "Cart Is Empty.",
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 16.0);
      return;
    } else {
      showDialog(
          builder: (context) => AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: const Text(
                    'Proceed with checkout?',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("Yes"),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (context) => CheckOutScreen(
                                    user: widget.user, total: _totalprice),
                              ),
                            )
                            .then((_) => setState(() {
                                  _loadMyCart();
                                }));
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
  }
}
