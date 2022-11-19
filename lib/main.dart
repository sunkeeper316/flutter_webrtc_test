import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:websocketapp/test_one_view.dart';
import 'package:websocketapp/websocket_server.dart';

import 'bottomnavigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> messages = [];
  TextEditingController tecMessage = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('initState');
    // server_start();
    // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    // FlutterLocalNotificationsPlugin();
    // flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
    //     AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  }


  void server_start()  {
    WebWocketServer.share = WebWocketServer();
    WebWocketServer.share?.set(context);
    WebWocketServer.share!.handler = (message) {
      setState(() {
        messages.add(message);
      });
    };

  }

  void send(String message){
    WebWocketServer.share?.send(message);
    messages.add(tecMessage.text);
  }

  @override
  void deactivate() {
    print('deactivate');

  }

  @override
  void dispose() {
    print('dispose');
    super.dispose();

  }



  void close(){

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Go to the SettingShowUsersView page',
            onPressed: () async {
              // WebWocketServer.share?.closeListen();
              Navigator.pushReplacement(context, MaterialPageRoute(maintainState: false, builder : (BuildContext context) => BottomNavigationController(title: 'test',)))
                  .then((value) {
                    print("test");
                WebWocketServer.share!.handler = (message) {
                  setState(() {
                    messages.add(message);
                  });
                };
              });
            },
          ),
        ],
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  // messages[index].sender == currentUser?.userId.toString() ?   Alignment.centerRight :

                  return Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(
                              right: 20, left: 20, top: 5, bottom: 5),
                          padding: const EdgeInsets.all(10),
                          constraints: BoxConstraints(minHeight: 40 , maxWidth: MediaQuery.of(context).size.width - 100),
                          decoration: BoxDecoration(
                            color: Colors.grey, //messages[index].sender == currentUser?.userId.toString() ?   Colors.blue :
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            messages[index],
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      )
                    ],
                  );

                }),
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.picture_in_picture),
                  tooltip: 'Icon pic send',
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: tecMessage,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(200)
                    ],
                    onSubmitted: (text) {
                      send(text);
                    },
                    // textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.green,
                      contentPadding: EdgeInsets.only(right: 5, left: 5),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                      labelText: '',
                      // labelStyle: TextStyle(color:  , ),
                      hintText: '請輸入...',
                      // prefixIcon: getPrefixIcon('account'),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                  tooltip: 'Go to ',
                  onPressed: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      if (tecMessage.text.trim() != "") send(tecMessage.text);

                      currentFocus.unfocus();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
