import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:symlercooksbake/model/product.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:symlercooksbake/model/user.dart';
import 'package:symlercooksbake/widget/orderbutton.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';



// ignore: camel_case_types
class info extends StatefulWidget {
  final User user;
  final Product product;
  const info({Key? key, required this.product, required this.user,}) : super(key: key);

  @override
  _infoState createState() => _infoState();
}

// ignore: camel_case_types
class _infoState extends State<info> {
  late double screenHeight, screenWidth, resWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar( centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0.5,
      backgroundColor: Colors.black,
      title: Text('Symler Cooks & Bake',
      style: GoogleFonts.pacifico(fontSize: 30), 
        ),
        
      ),
     
      body: SingleChildScrollView(
          child: Column(
        children: [
          
          SizedBox(
              width: screenWidth,
              height: 1 / 3 * screenHeight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: ImageSlideshow(
                  initialPage: 0,
                  children: [
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: "https://symlercooksbake.000webhostapp.com/directory/images/" +
                          widget.product.prid.toString() +
                          "_1.jpg",
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: "https://symlercooksbake.000webhostapp.com/directory/images/" +
                          widget.product.prid.toString() +
                          "_2.jpg",
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: "https://symlercooksbake.000webhostapp.com/directory/images/" +
                          widget.product.prid.toString() +
                          "_3.jpg",
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ],
                  autoPlayInterval: 3000,
                  isLoop: true,
                ),
              )),
              
             Text(widget.product.prname.toString(), textAlign: TextAlign.center,
              style: GoogleFonts.pacifico(fontWeight: FontWeight.w900, fontSize: 25 )),
              
              
              
                
          Padding(
            
            padding: const EdgeInsets.all(15.0),
            child: Card(
              
              elevation: 10,
              child: Container(
                
                padding: const EdgeInsets.all(10),
                child: Table(
                  columnWidths: const {
                    0: FractionColumnWidth(0.3),
                    1: FractionColumnWidth(0.7)
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  children: [
                    
                    TableRow(children: [
                      
                      const Text('Description', textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'League Spartan',
                            fontSize: 16, 
                            fontWeight: FontWeight.bold)),
                     Text(widget.product.prdesc.toString(),  textAlign: TextAlign.center,
                     style: const TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'League Spartan',
                            fontSize: 14, 
                            fontWeight: FontWeight.normal)),
                            
                    ]),
                     const TableRow(children: [
                      
                      Text('',
                          style: TextStyle()),
                    Text('',
                     style: TextStyle()),
                            
                    ]),
              
                    TableRow(children: [
                      const Text('Ingredients', textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'League Spartan',
                            fontSize: 16, 
                            fontWeight: FontWeight.bold)),
                      Text(widget.product.pringredient.toString(), textAlign: TextAlign.center,
                     style: const TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'League Spartan',
                            fontSize: 14, 
                            fontWeight: FontWeight.normal)),
                    ]),
                    const TableRow(children: [
                      
                      Text('',
                          style: TextStyle()),
                    Text('',
                     style: TextStyle()),
                            
                    ]),
                    
                    TableRow(children: [
                      const Text('Allergens', textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'League Spartan',
                            fontSize: 16, 
                            fontWeight: FontWeight.bold)),
                      Text(widget.product.prallergen.toString(),  textAlign: TextAlign.center,
                     style: const TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'League Spartan',
                            fontSize: 14, 
                            fontWeight: FontWeight.normal)),
                    ]),

                     const TableRow(children: [
                      
                      Text('',
                          style: TextStyle()),
                    Text('',
                     style: TextStyle()),
                            
                    ]),

                    TableRow(children: [
                      const Text('Weight', textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'League Spartan',
                            fontSize: 16, 
                            fontWeight: FontWeight.bold)),
                      Text(widget.product.prweight.toString(),  textAlign: TextAlign.center,
                     style: const TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'League Spartan',
                            fontSize: 14, 
                            fontWeight: FontWeight.normal)), 
 
                    ]),
                   const TableRow(children: [
                      
                      Text('',
                          style: TextStyle()),
                    Text('',
                     style: TextStyle()),
                            
                    ]),

                  TableRow(children: [
                      
                      const Text('',
                          style: TextStyle()),
                      Text("RM " +
                          double.parse(widget.product.prprice.toString())
                              .toStringAsFixed(2) ,  textAlign: TextAlign.center,
                     style: GoogleFonts.lobster(fontSize:25, color: Colors.pinkAccent, ) ),
                    ]),

                  
                  ]),
                  
                  
              ),
            ),
          ),
        ],
      )
      
      ),
       
       floatingActionButton: OrderButton(
        size: size,
        press: () {
          _addtocart();
     
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
      
    );
  }

  _addtocart() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Add to cart"), title: const Text("Progress..."));
    progressDialog.show();
    await Future.delayed(const Duration(seconds: 1));
    http.post(
        Uri.parse(
            "https://symlercooksbake.000webhostapp.com/directory/php/add_cart.php"),
        body: {
          "email": widget.user.email,
          "prid": widget.product.prid
        }).then((response) {
      if (response.body == "Failed") {
        Fluttertoast.showToast(
            msg: "Failed", toastLength: Toast.LENGTH_SHORT, fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Success", toastLength: Toast.LENGTH_SHORT, fontSize: 16.0);
        Navigator.pop(context);
      }
    });
    progressDialog.dismiss();
  }
    
  }

  


  