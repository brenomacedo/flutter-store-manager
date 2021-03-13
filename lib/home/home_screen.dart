import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:loja/blocs/orders_bloc.dart';
import 'package:loja/blocs/user_bloc.dart';
import 'package:loja/tabs/orders_tab.dart';
import 'package:loja/tabs/products_tab.dart';
import 'package:loja/tabs/users_tab.dart';
import 'package:loja/widgets/edit_category_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PageController _pageController;
  OrdersBloc _ordersBloc;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _ordersBloc = OrdersBloc();
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget _buildFloating() {
      switch(_page) {
        case 0:
          return null;
        case 1:
          return SpeedDial(
            children: [
              SpeedDialChild(
                child: Icon(Icons.arrow_downward, color: Colors.pinkAccent),
                backgroundColor: Colors.white,
                label: "Concluidos abaixo",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
                }
              ),
              SpeedDialChild(
                child: Icon(Icons.arrow_upward, color: Colors.pinkAccent),
                backgroundColor: Colors.white,
                label: "Concluidos acima",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
                }
              )
            ],
            icon: Icons.sort,
            backgroundColor: Colors.pinkAccent,
            overlayOpacity: 0.4,
            overlayColor: Colors.black
          );
        case 2:
          return FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.pinkAccent,
            onPressed: () {
              showDialog(context: context, builder: (context) {
                return EditCategoryDialog();
              });
            },
          );
        default:
          return null;
      }
    }

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
        child: BlocProvider(
          child: PageView(
            onPageChanged: (p) {
              setState(() {
                _page = p;            
              });
            },
            controller: _pageController,
            children: [
              UsersTab(),
              OrdersTab(),
              ProductsTab()
            ],
          ),
          blocs: [Bloc((i) => UserBloc()), Bloc((i) => _ordersBloc)],
        )
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  
}