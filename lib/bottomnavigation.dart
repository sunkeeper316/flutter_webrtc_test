
import 'package:flutter/material.dart';
import 'package:websocketapp/test_one_view.dart';
import 'package:websocketapp/view/test_two_view.dart';
// import 'package:websocketapp/test_two_view.dart';
import 'package:websocketapp/websocket_server.dart';

import 'common/extension_widget.dart';




class BottomNavigationController extends BaseView {
  BottomNavigationController({required super.title});


  @override
  BottomNavigationState createState() => BottomNavigationState();
}

class BottomNavigationState extends BaseState {

  static int _currentIndex = 0;
  final pages = [
    TestOneView(title: 'TestOneView',), TestTwoView(title: 'TestTwoView',)];

  final _items = [
    const BottomNavigationBarItem(icon: Icon(Icons.home) ,label: '' ,backgroundColor: Colors.blue,),
    const BottomNavigationBarItem(icon: Icon(Icons.people) ,label: '',backgroundColor: Colors.blue,),
    // const BottomNavigationBarItem(icon: Icon(Icons.message),label: '',backgroundColor: Colors.blue,),
    // const BottomNavigationBarItem(icon: Icon(Icons.view_list),label: '',backgroundColor: Colors.blue,),
  ];
  // GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    print('BottomNavigationState');
    // checkNetwork(context);
    // server_start();
  }
  void server_start()  {
    WebWocketServer.share = WebWocketServer();
    WebWocketServer.share?.set(context);
    WebWocketServer.share!.handler = (message) {
      setState(() {
        // messages.add(message);
      });
    };

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.black,
        backgroundColor: Colors.blue,
        items: _items,
        currentIndex: _currentIndex,
        onTap: (int) {
          setState(() {
            _currentIndex = int;
          });
        },
      ),

    );
  }
  @override
  void dispose() {
    // listener.cancel();
    super.dispose();
    print('vBottomNavigationController dispose');
  }

}



