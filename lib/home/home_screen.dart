import 'package:flutter/material.dart';
import 'package:loja/tabs/users_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.pinkAccent,
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
            caption: TextStyle(color: Colors.white54)
          )
        ),
        child: BottomNavigationBar(
          onTap: (p) {
            _pageController.animateToPage(p, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Clientes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Pedidos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Produtos',
            )
          ],
          currentIndex: _page,
        ),
      ),
      body: SafeArea(
        child: PageView(
          onPageChanged: (p) {
            setState(() {
              _page = p;            
            });
          },
          controller: _pageController,
          children: [
            UsersTab(),
            Container(color: Colors.yellow),
            Container(color: Colors.blue)
          ],
        ),
      )
    );
  }
}