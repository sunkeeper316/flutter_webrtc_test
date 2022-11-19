
import 'dart:convert';

class MessageData {
  int? messageDataId;
  String? chat;
  String? type;
  String? sender;
  List<String>? receiver;
  String? messageContent;
  Description? description;
  String? createTimestamp;

  MessageData({this.messageDataId , this.chat, this.type, this.sender, this.receiver, this.messageContent , this.description, this.createTimestamp});

  MessageData.fromJson(Map<String, dynamic> json) {
    print(json['description']);
    messageDataId = json['messageDataId'];
    chat = json['chat'];
    type = json['type'];
    sender = json['sender'];
    receiver = json['receiver'].cast<String>();
    messageContent = json['message_content'];
    description = Description.fromJson(json['description']) ;
    createTimestamp = json['createTimestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageDataId'] = this.messageDataId;
    data['chat'] = this.chat;
    data['type'] = this.type;
    data['sender'] = this.sender;
    data['receiver'] = this.receiver;
    data['message_content'] = this.messageContent;
    data['description'] = this.description;
    data['createTimestamp'] = this.createTimestamp;
    return data;
  }
}

class Description {
  String? _sdp;
  String? _type;

  Description({String? sdp, String? type}) {
    if (sdp != null) {
      this._sdp = sdp;
    }
    if (type != null) {
      this._type = type;
    }
  }

  String? get sdp => _sdp;
  set sdp(String? sdp) => _sdp = sdp;
  String? get type => _type;
  set type(String? type) => _type = type;

  Description.fromJson(Map<String, dynamic> json) {
    _sdp = json['sdp'];
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sdp'] = this._sdp;
    data['type'] = this._type;
    return data;
  }
}