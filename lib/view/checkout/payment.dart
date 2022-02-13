import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:symlercooksbake/mainpage.dart';

import 'package:symlercooksbake/model/payment.dart';
import 'package:symlercooksbake/model/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final Payment payment;

  const PaymentScreen({Key? key, required this.payment, required this.user}) : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => Home(user: widget.user)));
            }),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.5,
        backgroundColor: Colors.black,
        title:  Text('Payment',
            style:  GoogleFonts.pacifico(fontSize: 32, color: Colors.white,
                fontWeight: FontWeight.normal)),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: WebView(
                  initialUrl:
                      "https://symlercooksbake.000webhostapp.com/directory/php/generate_bill.php?email=" +
                          widget.payment.email +
                          '&mobile=' +
                          widget.payment.phone +
                          '&name=' +
                          widget.payment.name +
                          '&amount=' +
                          widget.payment.amount,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
