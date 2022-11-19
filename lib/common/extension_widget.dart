

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:websocketapp/websocket_server.dart';

class BaseView extends StatefulWidget {
  const BaseView({super.key, required this.title});
  final String title;

  @override
  State<BaseView> createState() => BaseState();
}

class BaseState extends State<BaseView> {

  @override
  void initState() {

    print('BaseState initState');
    super.initState();
    if (WebWocketServer.share == null){
      WebWocketServer.share = WebWocketServer();
    }
    WebWocketServer.share!.set(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Scaffold();
  }
}
// extension BaseFulWidget on  State<T extends StatefulWidget> {
//
//
//   @override
//   void initState() {
//     super.initState();
//     print('BaseFulWidget');
//     if (WebWocketServer.share == null){
//       WebWocketServer.share = WebWocketServer();
//       WebWocketServer.share!.set(context);
//
//
//     }
//
//   }
// }
//BaseFulWidget
// mixin  BaseState on State {
//
//   @override
//   void initState() {
//     super.initState();
//     print('mixin initState');
//     if (WebWocketServer.share == null){
//
//       WebWocketServer.share = WebWocketServer();
//
//     }
//   }
// }