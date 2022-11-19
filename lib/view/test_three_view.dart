import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:websocketapp/common/extension_widget.dart';
import 'package:websocketapp/websocket_server.dart';

class TestThreeView extends BaseView {
  TestThreeView({required super.title});

  // const MyHomePage({super.key, required this.title});
  // final String title;
  @override
  TestThreeState createState() => TestThreeState();
}

class TestThreeState extends BaseState {

  List<String> messages = [];
  TextEditingController tecMessage = TextEditingController();

  final streamController = StreamController.broadcast();
  StreamSubscription? streamSubscription;

  @override
  void initState() {
    super.initState();
    server_start();
  }
  void server_start()  {
    WebWocketServer.share!.handler = (message) {
      setState(() {
        messages.add(message);
      });
    };

  }
  @override
  void dispose() {
    super.dispose();
    // streamSubscription?.cancel();
    // streamController.close();
    // WebWocketServer.share?.handler = null;
    print("dispose");
  }

  @override
  void deactivate() {
    print('deactivate');
    // streamSubscription?.cancel();
    // streamController.close();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Go to the SettingShowUsersView page',
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SettingShowUsersView()));
            },
          ),
        ],
        title: Text('TestThreeView'),
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
                      messages.add(text);
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
                      if (tecMessage.text.trim() != "") messages.add(tecMessage.text);
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
