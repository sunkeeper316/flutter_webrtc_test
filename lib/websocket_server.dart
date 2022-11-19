import 'dart:async';
import 'dart:convert';

// import 'package:datingflutterapp/model/websocket/message_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/status.dart';
import 'package:websocketapp/call_view.dart';
import 'package:websocketapp/message_data.dart';
import 'package:websocketapp/common/showDialog.dart';
import 'package:websocketapp/common/showSnackBar.dart';
import 'package:websocketapp/view/test_three_view.dart';
// import '../websocket/webrtc_data.dart';
// import 'api_server.dart';

// WebWocketServer? webWocketServer;

class WebWocketServer {
  static WebWocketServer? share;
  static var calling = false;
  late IOWebSocketChannel channel ;

  StreamSubscription?  streamSubscription;

  void Function(String)? handler;

  BuildContext? context;




  WebWocketServer(){
    channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.100.3:3000') //wss://181d-118-170-211-55.jp.ngrok.io    ws://192.168.100.3:3000
        ,headers: {
          "Authorization":"Bearer "});
    streamSubscription = channel.stream.listen((message) {
      print("${message}");
      MessageData data = MessageData.fromJson(jsonDecode(message));
      if (data.type == "offer"){

        if (calling){
          if (handler != null) handler!(message);
        }else{
          showCheckDialog(context! , null , '注意！ 電話來摟','確定取消？' ,() {
            calling = true;
            Navigator.push(context!, MaterialPageRoute(builder: (BuildContext context) => CallView(title: 'TestThreeView', messageData: data)));
          });
        }

      }else {
        calling = true;
        if (handler != null) handler!(message);
      }


    });
  }

  void set(BuildContext context){
    this.context = context;
  }

  void closeListen() async {
    await streamSubscription?.cancel();
    streamSubscription?.resume();
    await channel.sink.close(status.goingAway);

  }

  void send(String message){
  channel.sink.add(message);
  }


  void close(){
    channel.sink.close(status.goingAway);

  }
}

