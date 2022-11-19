

import 'package:flutter_webrtc/flutter_webrtc.dart';

// final Map<String, dynamic> peerConnectionConfig = {
//   'mandatory': {},
//   'optional': [
//     {'DtlsSrtpKeyAgreement': true},
//   ]
// };

final constraints = <String, dynamic>{
  'mandatory': {},
  'optional': [
    {'DtlsSrtpKeyAgreement': false},
  ],
};

final Map<String, dynamic> dcConstraints = {
  'mandatory': {
    'OfferToReceiveAudio': true,
    'OfferToReceiveVideo': true,
  },
  'optional': [],
};

/*
       * turn server configuration example.
      {
        'url': 'turn:123.45.67.89:3478',
        'username': 'change_to_real_user',
        'credential': 'change_to_real_secret'
      },
      */
final Map<String, dynamic> iceServers = {
  'iceServers':
  [],
  'sdpSemantics': 'unified-plan'
};
//{'url': 'stun:stun.l.google.com:19302'},{'url': 'stun:stun1.l.google.com:19302'},{'url': 'stun:stun2.l.google.com:19302'},{'url': 'stun:stun3.l.google.com:19302'},
String get sdpSemantics => 'unified-plan';

class WebRTCData {
  int? messageDataId;
  String? chat;
  String? type;
  String? sender;
  List<String>? receiver;
  Map<String, dynamic>? description;
  String? createTimestamp;

  WebRTCData(
      { this.messageDataId , this.chat, this.type, this.sender, this.receiver, this.description , this.createTimestamp}
      );

  WebRTCData.fromJson(Map<String, dynamic> json) {
    messageDataId = json['messageDataId'];
    chat = json['chat'];
    type = json['type'];
    sender = json['sender'];
    receiver = json['receiver'].cast<String>();
    description = json['description'];
    createTimestamp = json['createTimestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageDataId'] = this.messageDataId;
    data['chat'] = this.chat;
    data['type'] = this.type;
    data['sender'] = this.sender;
    data['receiver'] = this.receiver;
    data['description'] = this.description;
    data['createTimestamp'] = this.createTimestamp;
    return data;
  }

  // Future<void> _createOffer(MediaStream  _localStream,Session session, String media) async {
  //   try {
  //     RTCPeerConnection pc = await createPeerConnection({
  //       ..._iceServers,
  //       ...{'sdpSemantics': sdpSemantics}
  //     }, _config);
  //
  //     pc.onTrack = (event) {
  //       if (event.track.kind == 'video') {
  //         onAddRemoteStream?.call(newSession, event.streams[0]);
  //       }
  //     };
  //     List<RTCRtpSender> _senders = <RTCRtpSender>[];
  //     _localStream.getTracks().forEach((track) async {
  //       _senders.add(await pc.addTrack(track, _localStream));
  //     });
  //
  //     RTCSessionDescription s =
  //     await pc.createOffer(media == 'data' ? _dcConstraints : {});
  //     // await session.pc!.setLocalDescription(_fixSdp(s));
  //     // _send('offer', {
  //     //   'to': session.pid,
  //     //   'from': _selfId,
  //     //   'description': {'sdp': s.sdp, 'type': s.type},
  //     //   'session_id': session.sid,
  //     //   'media': media,
  //     // });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}

enum CallState {
  CallStateNew,
  CallStateRinging,
  CallStateInvite,
  CallStateConnected,
  CallStateBye,
}

class Session {
  Session({required this.sid, required this.pid});
  String pid;
  String sid;
  RTCPeerConnection? pc;
  RTCDataChannel? dc;
  List<RTCIceCandidate> remoteCandidates = [];
}