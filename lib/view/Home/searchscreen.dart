import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:symlercooksbake/model/product.dart';
import 'package:symlercooksbake/model/user.dart';
import 'package:symlercooksbake/view/Home/detailscreen.dart';
import 'package:symlercooksbake/widget/loading.dart';

class Search extends StatefulWidget {
  final User user;
  

  const Search({Key? key, required this.user}) : super(key: key);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List _productList =[];
  late Product product;
  String _titlecenter = "Search by Product Name.";
  String _imagecenter = "assets/images/search.png";

  final TextEditingController _searchController = TextEditingController();
  late double screenHeight, screenWidth;
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
        title: _searchTextField(),
        actions: _buildActions(),
      ),
      body: SafeArea(
        child: Column(children: [
          // ignore: unnecessary_null_comparison
          _productList == null
              ? Flexible(
                  child: Center(
                  child: _titlecenter == ""
                      ? const Loading()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              _imagecenter,
                              height: 300,
                              width: 150,
                            ),
                            const SizedBox(height: 10),
                            Text(_titlecenter,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 20),
                          ],
                        ),
                ))
              : Flexible(
                  child: Center(
                    child: Column(children: [
                      // ignore: unnecessary_null_comparison
                      _productList.length == null
                          ? const Flexible(
                              child: Center(
                                  child: Text(
                                      "This food not available in Symler Cooks & Bake.",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold))))
                          : Flexible(
                              child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: GridView.builder(
                                  itemCount: _productList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          mainAxisExtent: 350,
                                          ),
                                  itemBuilder:
                                      (BuildContext context, int data) {
                                    return Card(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                          topLeft:  Radius.circular(40.0),
                                          topRight: Radius.circular(40.0), ),
                                                                
                                                                  
                                          
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl:
                                                        "https://symlercooksbake.000webhostapp.com/directory/images/" +
                             _productList[data]['prid'] +
                             "_1.jpg",
                                                    height: 200,
                                                    width: 150,
                                                  )
                                                ]),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 10, 5, 10),
                                                  child: Text(
                                                      titleSub(
                                                          _productList[data]
                                                              ['prname']),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                  
                                                      const EdgeInsets.fromLTRB(
                                                          10, 10, 5, 0),
                                                  child: Text(
                                                    "Price: RM " +
                                                        _productList[data]
                                                            ['prprice'] + ".00",
                                                            style:
                                                        const TextStyle(fontSize: 16, color: Colors.pinkAccent),
                                                         
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.black,
                                              ),
                                              onPressed: () => {
                                                product = Product(
                                                  prid:
                                                      _productList[data]
                                                          ['prid'],
                                                  primage:
                                                      CachedNetworkImage(
                                                    imageUrl:
                                                        "https://symlercooksbake.000webhostapp.com/directory/images/" +
                             _productList[data]['prid'] +
                             "_1.jpg",
                                                    fit: BoxFit.cover,
                                                  ),
                                                  prname:
                                                      _productList[data]
                                                          ['prname'],
                                                  prprice:
                                                      _productList[data]
                                                          ['prprice'],
                                                  prdesc:
                                                      _productList[data]
                                                          ['prdesc'],
                                                  prallergen:
                                                      _productList[data]
                                                          ['prallergen'],
                                                          prweight:
                                                          _productList[data]
                                                          ['prweight'],
                                                  pringredient:
                                                      _productList[data]
                                                          ['pringredient'],
                                                ),
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (content) =>
                                                            info(
                                                              product : product, user : widget.user
                                                              
                                                            )))
                                              },
                                              child: const Text("View More"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )),
                    ]),
                  ),
                )
        ]),
      ),
    );
  }

  Widget _searchTextField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          if (_searchController.text.isEmpty) {
            _isSearching = false;
            _loadProducts("null");
            _productList = [];
          } else {
            _loadProducts(value);
            _isSearching = true;
          }
        });
      },
      decoration: const InputDecoration(
        hintText: "Search flavour...",
        border: InputBorder.none,
        hintStyle: TextStyle(fontSize: 20, color: Colors.white54),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            FocusScope.of(context).unfocus();
            setState(() {
              _loadProducts("null");
              _imagecenter = "assets/images/search.png";
              _titlecenter = "Search by Product Name.";
              _productList = [];
              _searchController.clear();
              _isSearching = false;
            });
          },
        ),
      ];
    }
    return <Widget>[
      IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => setState(() {
                if (_searchController.text.isNotEmpty) {
                  _loadProducts(_searchController.text);
                  _isSearching = true;
                }
              })),
    ];
  }

  void _loadProducts(String _prname) {
    http.post(
        Uri.parse(
            "https://symlercooksbake.000webhostapp.com/directory/php/load_products.php"),
        body: {"prname": _prname}).then((response) {
      if (response.body == "nodata") {
        _imagecenter = "assets/images/searchnotfound.png";
        _titlecenter = "Not available in Symler Cooks & Bake.";
        setState(() {});
        return;
      } else if (response.body == "nullnodata") {
        _imagecenter = "assets/images/search.png";
        var jsondata = json.decode(response.body);
        _titlecenter = "Search by Product Name.";
        _productList = jsondata["products"];
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        _productList = jsondata["products"];
        setState(() {});
      }
    });
  }

  String titleSub(String title) {
    if (title.length > 14) {
      return title.substring(0, 14) + "...";
    } else {
      return title;
    }
  }
}
