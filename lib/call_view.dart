

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:websocketapp/common/extension_widget.dart';
import 'package:websocketapp/common/webrtc_data.dart';
import 'package:websocketapp/websocket_server.dart';

import 'message_data.dart';


class CallView extends BaseView {
  static String tag = 'call_view';
  // late int user_id;
  MessageData? messageData;
  // CallView({required super.title});

  CallView({required super.title , this.messageData}) : super();
  // final String host;
  // CallSample({required this.host});

  @override
  CallState createState() => CallState(this.messageData);
}

class CallState extends BaseState {

  // WebWocketServer? webWocketServer = null;

  // late int user_id;
  MessageData? messageData;
  bool _inCalling = false;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  RTCPeerConnection? _peerConnection;
  // RTCPeerConnection? _remotePeerConnection;

  MediaStream? _localStream;
  List<MediaStream> _remoteStreams = <MediaStream>[];

  CallState(this.messageData);

  @override
  initState() {
    super.initState();
    initRenderers();
    server_start();

  }
  void server_start()  {
    WebWocketServer.share!.handler = (message) async {
      MessageData data = MessageData.fromJson(jsonDecode(message));
      if (data.type == 'answer'){
        print('data.type == answer');
        await _peerConnection?.setRemoteDescription(RTCSessionDescription(data.description?.sdp, data.description?.type));

      }else if (data.type == 'offer'){
        print('data.type == offer');
        await _peerConnection?.setRemoteDescription(RTCSessionDescription(data?.description?.sdp, data?.description?.type));
        RTCSessionDescription? rtcSessionDescription = await _createAnswer();
        sendAnswer(rtcSessionDescription);
      }
      setState(() {

      });
    };

  }
  @override
  void deactivate() {
    print('deactivate');
    // webWocketServer?.close();
    _localRenderer.srcObject = null;
    _localRenderer.srcObject = null;
    _localRenderer.dispose();
    _remoteRenderer.dispose();

  }

  @override
  Widget build(BuildContext context) {
    print("WebRTC.platformIsDesktop ${WebRTC.platformIsDesktop}");
    return Scaffold(
      appBar: AppBar(
        title: Text('${messageData?.createTimestamp}'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              RTCSessionDescription? rtcSessionDescription = await _createOffer();
              print('offer \n${rtcSessionDescription?.sdp}');
              sendOffer(rtcSessionDescription);
            },
            tooltip: 'setup',
          ),
        ],
      ),
      body:  OrientationBuilder(builder: (context, orientation) {
        return Container(
          child: Stack(children: <Widget>[
            Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                bottom: 0.0,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: RTCVideoView(_remoteRenderer , mirror: true),
                  decoration: BoxDecoration(color: Colors.black54),
                )),
            Positioned(
              left: 20.0,
              top: 20.0,
              child: Container(
                width: orientation == Orientation.portrait ? 90.0 : 120.0,
                height:
                orientation == Orientation.portrait ? 120.0 : 90.0,
                child: RTCVideoView(_localRenderer, mirror: true),
                decoration: BoxDecoration(color: Colors.black54),
              ),
            ),
          ]),
        );
      }),
    );
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    await createStream('video' , true);
    await _createPeerConnection();
    // await _createremotePeerConnection();
    if ( messageData != null ) {
      print('messageData != null');
      print(messageData?.type);
      print(messageData?.description);
      await _peerConnection?.setRemoteDescription(RTCSessionDescription(messageData?.description?.sdp, messageData?.description?.type));
      RTCSessionDescription? rtcSessionDescription = await _createAnswer();
      sendAnswer(rtcSessionDescription);
    }else{
      RTCSessionDescription? rtcSessionDescription = await _createOffer();
      print('offer \n${rtcSessionDescription?.sdp}');
      sendOffer(rtcSessionDescription);
    }
    setState(() {});
  }

  void sendOffer(RTCSessionDescription? rtcSessionDescription) {
    MessageData messageData = MessageData();
    // messageData.description = {'sdp': rtcSessionDescription?.sdp, 'type': rtcSessionDescription?.type};
    messageData.description = Description(sdp:rtcSessionDescription?.sdp , type: rtcSessionDescription?.type);
    messageData.sender = "";
    messageData.receiver = [""];
    messageData.chat = "single";
    messageData.type = "offer";
    WebWocketServer.share!.send(jsonEncode(messageData.toJson()));
  }

  void sendAnswer(RTCSessionDescription? rtcSessionDescription) {
    MessageData messageData = MessageData();
    // messageData.description = {'sdp': rtcSessionDescription?.sdp, 'type': rtcSessionDescription?.type};
    messageData.description = Description(sdp:rtcSessionDescription?.sdp , type: rtcSessionDescription?.type);
    messageData.sender = "";
    messageData.receiver = [""];
    messageData.chat = "single";
    messageData.type = "answer";
    WebWocketServer.share!.send(jsonEncode(messageData.toJson()));
  }
  final Map<String, dynamic> offerSdpConstraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": true,
    },
    "optional": [],
  };
  Future<void>  _createPeerConnection() async {
    try {
      _peerConnection = await createPeerConnection(iceServers,constraints);
      for (var track in _localStream!.getVideoTracks()) {
        await _peerConnection?.addTrack(track, _localStream!);
      }
      // if (_localStream != null) await pc.addStream(_localStream!);
      _peerConnection?.onIceCandidate = (candidate) async {
        print('onIceCandidate');
        try {
          var _candidate = RTCIceCandidate(
            candidate.candidate!,
            candidate.sdpMid!,
            candidate.sdpMLineIndex!,
          );
          await _peerConnection!.addCandidate(_candidate);
        } catch (e) {
          print(
              'Unable to add candidate ${candidate.candidate} to local connection');
        }
      };
      _peerConnection?.onIceConnectionState = (e) {
        print('onIceConnectionState ${e.name}');
        // print(e.name);
      };
      // _peerConnection?.onAddStream = (stream){
      //   print('addStream: ' + stream.id);
      //   // _remoteRenderer.srcObject = stream;
      //   setState(() {
      //     _remoteRenderer.srcObject = stream;
      //   });
      // };
      _peerConnection?.onTrack = (RTCTrackEvent event) async {
        print('onTrack: ${event?.track?.id}' );
        var stream  = await createLocalMediaStream(event.track.id!);
        await stream.addTrack(event.track);

        setState(() {
          _remoteRenderer.srcObject = stream;
        });
      };

    } catch (e) {
      print(e.toString());
      Future.error(e.toString());
    }
  }

  // Future<void>  _createremotePeerConnection() async {
  //   try {
  //     _remotePeerConnection = await createPeerConnection(iceServers,constraints);
  //     _remotePeerConnection?.onIceCandidate = (candidate) async {
  //       print('onIceCandidate');
  //       print(candidate.candidate);
  //       await _peerConnection?.addCandidate(candidate);
  //     };
  //     _remotePeerConnection?.onIceConnectionState = (e) {
  //       print('onIceConnectionState');
  //       print(e.name);
  //     };
  //     _remotePeerConnection?.onAddStream = (stream){
  //       // print('addStream: ' + stream.id);
  //       // _remoteRenderer.srcObject = stream;
  //       // setState(() {
  //       //
  //       // });
  //     };
  //     _remotePeerConnection?.onTrack = (RTCTrackEvent event) async {
  //       print('onTrack: ${event?.track?.id}' );
  //
  //       var stream  = await createLocalMediaStream(event.track.id!);
  //       await stream.addTrack(event.track);
  //       setState(() {
  //         _remoteRenderer.srcObject = stream;
  //       });
  //     };
  //
  //
  //
  //   } catch (e) {
  //     print(e.toString());
  //     Future.error(e.toString());
  //   }
  // }
  Future<RTCSessionDescription?> _createOffer() async {
    try {

      RTCSessionDescription description = await _peerConnection!.createOffer(dcConstraints) ;
      await _peerConnection?.setLocalDescription(description);
      return description;
    }catch (e) {
      print(e.toString());
      Future.error(e.toString());
    }
  }
  Future<RTCSessionDescription?> _createAnswer() async {
    try {

      RTCSessionDescription description = await _peerConnection!.createAnswer(dcConstraints) ;
      await _peerConnection?.setLocalDescription(description);
      return description;
    }catch (e) {
      print(e.toString());
      Future.error(e.toString());
    }
  }

  Future<MediaStream> createStream(String media, bool userScreen,
      {BuildContext? context}) async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video':  {
        'mandatory': {
          'minWidth': '640',
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      },
    };
    late MediaStream stream;
    if (userScreen) {
      if (WebRTC.platformIsDesktop) {
        stream = await navigator.mediaDevices.getDisplayMedia(<String, dynamic>{
          'audio': true,
          'video':  {
            'mandatory': {
              'minWidth': '640',
              'minHeight': '480',
              'minFrameRate': '30',
            },
            'facingMode': 'user',
            'optional': [],
          },
        });
      } else {
        stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      }
    } else {
      stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    }
    _localStream = stream;
    // if (_localStream != null){
    //   // await _removeExistingVideoTrack();
    //   var tracks = _localStream!.getTracks();
    //   for (var t in tracks) {
    //     await _localStream!.addTrack(t);
    //   }
    // }

    setState(() {
      _localRenderer.srcObject = _localStream;
    });

    // onLocalStream?.call(stream);
    return stream;
  }
}