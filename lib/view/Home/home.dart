import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:symlercooksbake/model/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:symlercooksbake/model/product.dart';
import 'package:symlercooksbake/view/Home/detailscreen.dart';
import 'package:symlercooksbake/view/Home/searchscreen.dart';

class Menu extends StatefulWidget {
  final User user;
  
  const Menu({Key? key, required this.user, }) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late double screenHeight, screenWidth, resWidth;
  List _productList = [];
  late Product product;
  late ScrollController _scrollController;
  int scount = 10;
  int rcount = 2;
   int cartitem = 0;
  int nroomdata = 0;
  final df = DateFormat('dd/MM/yyyy hh:mm a');

 
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadProducts("all");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rcount = 3;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.5,
        backgroundColor: Colors.black,
        title:  Text('Symler Cooks & Bake',
            style:  GoogleFonts.pacifico(fontSize: 32, color: Colors.white,
                fontWeight: FontWeight.normal )),
        
      ),
      
      body: _productList.isEmpty
          ? const Center(
              )
                      
          : Column(
              children: [
                Container(
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.search,
                  ),
                  title: GestureDetector(
                    onTap: () {
                      
                       Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (content) =>
                                      Search(user: widget.user)))
                          .then((_) => setState(() {
                                _loadCart();
                              }));
                      
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: const IgnorePointer(
                        child: TextField(
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: "Search Here",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          
          Expanded(
                 
            child: GridView.count(
            crossAxisCount: rcount,
            controller: _scrollController,
              children: List.generate(scount, (data) {
                return Card(
                  child: InkWell(
                  onTap: () => {_productdetails(data)},
                    child: Column(
                     children: [
                           
                      Flexible(
                       flex: 100,
                        child: CachedNetworkImage(
                        width: screenWidth,
                        height: 250,
                                
                         fit: BoxFit.cover,
                         imageUrl:
                           "https://symlercooksbake.000webhostapp.com/directory/images/" +
                             _productList[data]['prid'] +
                             "_1.jpg", 
                                        
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error), 
                                    
                              ),
                            ),
                            Flexible(
                                flex: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    children: [

                                      const SizedBox(
                                        height: 3,
                                         ),  

                                      Text(         
                                          truncateString(_productList[data]
                                                  ['prname']
                                              .toString().toUpperCase()),
                                              textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.blueGrey,                                              
                                              fontSize: resWidth * 0.045,
                                              fontFamily: 'League Spartan',
                                              fontWeight: FontWeight.bold)),

                                        const SizedBox(
                                        height: 10,
                                         ), 

                                      Row (children :<Widget>[ 
                                        const Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                        Icons.attach_money_outlined,
                                        color: Colors.blueGrey,
                                        size: 20.0, )),
                                      Flexible(child: Text(" RM " +
                                              _productList[data]['prprice'] +
                                              ".00",  textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.pinkAccent,  
                                            fontFamily: 'RobotoMono',
                                            fontSize: resWidth * 0.035,
                                          )),                                      
                                      ),
                                      ]),
                                       const SizedBox(
                                        height: 2,
                                         ), 
                                      Row (children :[ const Icon(
                                        Icons.cake_rounded,
                                        color: Colors.blueGrey,
                                        size: 20.0,),
                                      Flexible(child: Text("  "+_productList[data]['prweight'],
                                          style: TextStyle(
                                            color: Colors.blueGrey,  
                                            fontFamily: 'RobotoMono',
                                            fontSize: resWidth * 0.035,
                                          )),                                      
                                      ),
                                      ]
                                      ),
                                        const SizedBox(
                                        height: 10,
                                         ),    
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ));
                    }),
                  ),
                ),
              ],
            ),
    );
  }

  String truncateString(String str) {
    if (str.length > 40) {
      str = str.substring(0, 40);
      return str ;
    } else {
      return str;
    }
  }


  void _loadProducts(String _prname) {
    http.post(
        Uri.parse(
            "https://symlercooksbake.000webhostapp.com/directory/php/load_products.php"),
        body: {"prname": _prname}).then((response) {
      if (response.body == "nodata") {
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        _productList = jsondata["products"];
        setState(() {});
      }
    });
  }
  _productdetails(int data) {
    Product product = Product(
        prid: _productList[data]['prid'],
        primage: _productList[data]['primage'],
        prname: _productList[data]['prname'],
        prdesc: _productList[data]['prdesc'],
        pringredient: _productList[data]['pringredient'],
        prallergen: _productList[data]['prallergen'],
        prweight: _productList[data]['prweight'],
        prprice: _productList[data]['prprice'],);
        
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => info(
                  product: product, user : widget.user
                )));
  }
  
  
  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (_productList.length > scount) {
          scount = scount + 10;
          if (scount >= _productList.length) {
            scount = _productList.length;
          }
        }
      });
    }
  }
  void _loadCart() {
  http.post(
        Uri.parse(
            "https://symlercooksbake.000webhostapp.com/directory/php/load_cartqty.php"),
        body: {"email": widget.user.email}).then((response) {
      setState(() {
        cartitem = int.parse(response.body);
      });
    });
}
}


