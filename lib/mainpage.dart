import 'package:flutter/material.dart';
import 'package:symlercooksbake/model/user.dart';
import 'package:symlercooksbake/view/checkout/cartscreen.dart';
import 'package:symlercooksbake/view/Home/home.dart';
import 'package:symlercooksbake/view/account/accountscreen.dart.dart';

class Home extends StatefulWidget {
  final User user;
  const Home({Key? key, required this.user}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double screenHeight = 0.0, screenWidth = 0.0;
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Symler Cooks & Bake";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      Menu(
        user: widget.user,
      ),
      CartScreen(user: widget.user),
      TabPage3(
        user: widget.user
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
     
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        
        type: BottomNavigationBarType.shifting,
        unselectedItemColor: Colors.grey[600],
        selectedItemColor: Colors.black,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.perm_identity), label: "Account")
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        maintitle = "Home";
      }
      if (_currentIndex == 1) {
        maintitle = "Cart";
      }
      if (_currentIndex == 2) {
        maintitle = "Account";
      }
    });
  }
}
