import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:symlercooksbake/model/delivery.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late double screenHeight, screenWidth;
  double dis = 0;
  Set<Marker> markers = {};
  String _address = "No location selected.";
  late Delivery _delivery;
  Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _shopPosition = CameraPosition(
    target: LatLng(5.646969, 100.494445),
    zoom: 11.7,
  );

  @override
  void initState() {
    super.initState();
    showShopMarker();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.5,
        backgroundColor: Colors.black,
        title:  Text('Select Location',
            style:  GoogleFonts.pacifico(fontSize: 32, color: Colors.white,
                fontWeight: FontWeight.normal )),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Flexible(
                  flex: 7,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _shopPosition,
                    markers: markers.toSet(),
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                    onTap: (newLatLng) {
                      _loadAdd(newLatLng);
                    },
                  )),
              const Divider(
                height: 5,
              ),
              Flexible(
                  flex: 3,
                  child: Container(
                      width: screenWidth,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            const Text("Please select your delivery address from map",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: screenWidth / 1.2,
                              child: const Divider(),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      children: [
                                        Container(
                                            width: 200,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.black,
                                              ),
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            height: 100,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(_address),
                                            )),
                                        const SizedBox(height: 10),
                                        Text("Delivery distance :" +
                                            dis.toStringAsFixed(2) +
                                            "km")
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 50,
                                      child:
                                          VerticalDivider(color: Colors.black)),
                                  Expanded(
                                      flex: 4,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.black,
                                          ),
                                          onPressed: () {
                                            if (dis > 15) {
                                              Fluttertoast.showToast(
                                                msg: "Current Delivery Distance is " +
                                                    dis.toStringAsFixed(2) +
                                                    " KM. \nMaximum Delivery Distance is 15 KM. Please try again.",
                                                toastLength:
                                                    Toast.LENGTH_SHORT,
                                              );
                                              return;
                                            }
                                            Navigator.pop(
                                                context, _delivery);
                                          },
                                          child: const Text("Save",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight:
                                                    FontWeight.normal,
                                              ))))
                                ],
                              ),
                            ),
                          ],
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }

  void showShopMarker() {
    MarkerId markerId1 = const MarkerId("13");
    markers.add(Marker(
      markerId: markerId1,
      position: const LatLng(5.646969, 100.494445),
      infoWindow: const InfoWindow(
        title: 'Shop Location',
        snippet: "Symler Cakes & Bake",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
  }

  void _loadAdd(LatLng newLatLng) async {
    MarkerId markerId1 = const MarkerId("12");
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Searching address"), title: const Text("Locating..."));
    progressDialog.show();
    List<Placemark> newPlace =
        await placemarkFromCoordinates(newLatLng.latitude, newLatLng.longitude);

    Placemark placeMark = newPlace[0];
    String name = placeMark.name.toString();
    String subLocality = placeMark.subLocality.toString();
    String locality = placeMark.locality.toString();
    String administrativeArea = placeMark.administrativeArea.toString();
    String postalCode = placeMark.postalCode.toString();
    String country = placeMark.country.toString();
    _address = name +
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
    markers.clear();
    markers.add(Marker(
      markerId: markerId1,
      position: LatLng(newLatLng.latitude, newLatLng.longitude),
      infoWindow: InfoWindow(
        title: 'Address',
        snippet: _address,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ));
    dis = calculateDistance(newLatLng.latitude, newLatLng.longitude);
    _delivery = Delivery(_address, newLatLng);
    setState(() {});
    progressDialog.dismiss();
  }

  double calculateDistance(lat1, lon1) {
    var lat2 = 5.646969 ;
    var lon2 = 100.494445;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
