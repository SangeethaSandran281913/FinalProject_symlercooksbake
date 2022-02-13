import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:symlercooksbake/model/user.dart';
import 'package:symlercooksbake/widget/loading.dart';

class HistoryScreen extends StatefulWidget {
  final User user;

  const HistoryScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _titlecenter = "";
  List _historyList = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('Purchased History',
            style:  GoogleFonts.pacifico(fontSize: 32, color: Colors.white,
                fontWeight: FontWeight.normal )),
      ),
      body: Center(
        child: Column(
          children: [
            if (_historyList.isEmpty)
              Flexible(
                  child: Center(
                child: _titlecenter == ""
                    ? const Loading()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/purchasehistory.png",
                            height: 150,
                            width: 150,
                          ),
                          const SizedBox(height: 10),
                          const Text('Purchased History Is Empty!',
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
                      children: List.generate(_historyList.length, (index) {
                        return Padding(
                            padding: const EdgeInsets.all(3),
                            child: Card(
                                child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    _historyList[index]
                                                            ['orderid']
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Text(
                                                  "(" +
                                                      titleSub(_historyList[
                                                              index]
                                                          ['date_purchase']) +
                                                      ")",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Status :",
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 5,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Text(
                                                      _historyList[index]['status']
                                                          .toUpperCase(),
                                                      style: _historyList[index]['status']
                                                                      .toUpperCase() ==
                                                                  "PAID" ||
                                                              _historyList[index]['status']
                                                                      .toUpperCase() ==
                                                                  "DONE"
                                                          ? const TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)
                                                          : TextStyle(
                                                              fontSize: 18,
                                                              color: Colors
                                                                  .red[500],
                                                              fontWeight:
                                                                  FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                          ])),
                                  Expanded(
                                    flex: 7,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CachedNetworkImage(
                                                  imageUrl:
                                                      "https://symlercooksbake.000webhostapp.com/directory/images/${_historyList[index]['prid']}_1.jpg",
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.cover),
                                            ],
                                          ),
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
                                                      _historyList[index]
                                                          ['prname'],
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                
                                                const SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "RM " +
                                                          (int.parse(_historyList[
                                                                          index]
                                                                      [
                                                                      'qty']) *
                                                                  double.parse(
                                                                      _historyList[
                                                                              index]
                                                                          [
                                                                          'prprice']))
                                                              .toStringAsFixed(
                                                                  2),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      "Qty: " +
                                                          (int.parse(_historyList[
                                                                      index][
                                                                  'qty']))
                                                              .toStringAsFixed(
                                                                  0),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Subtotal: RM " +
                                                          double.parse(_historyList[
                                                                      index][
                                                                  'prprice'])
                                                              .toStringAsFixed(
                                                                  2),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )));
                      })),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String titleSub(String title) {
    if (title.length > 19) {
      return title.substring(0, 19);
    } else {
      return title;
    }
  }

  _loadHistory() {
    http.post(
        Uri.parse(
            "https://symlercooksbake.000webhostapp.com/directory/php/load_history.php"),
        body: {"email": widget.user.email}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "No item";
        _historyList = [];
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        _historyList = jsondata["history"];
      }
      setState(() {});
    });
  }
}
