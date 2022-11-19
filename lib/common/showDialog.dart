import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCheckDialog(BuildContext context, Image? image, String? title,
    String? show, void Function() handler) {
  double? hegiht = 30.0;
  if (image != null) {
    hegiht = null;
  }

  showDialog(
      context: context,
      builder: (BuildContext builder) => AlertDialog(
            title: Container(
              child: Text(
                title ?? '',
                style: const TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(builder);
                },
                child: const Text("取消"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(builder);
                  handler();
                },
                child: const Text("確定"),
              ),
            ],
            content: Container(
              // height: hegiht,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: image,
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      show ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ));
}

void showInputDialog(
    BuildContext context, String? title, void Function(String text) handler) {
  TextEditingController controller = TextEditingController();

  showDialog(
      context: context,
      builder: (BuildContext builder) => AlertDialog(
            title: Container(
              child: Text(
                title ?? '',
                style: const TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.pop(builder);
                },
                child: const Text("取消"),
              ),
              TextButton(
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.pop(builder);
                  handler(controller.text);
                },
                child: const Text("確定"),
              ),
            ],
            content: Container(
              // height: hegiht,
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '請回覆老師的話...',
                ),
              ),
            ),
          ));
}

void showCupertinoPicker(
    BuildContext context, List<String> options, void Function(String option) handler) {
  int index = 0;
  showDialog(
      context: context,
      builder: (BuildContext builder) => AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  handler(options[index]);
                  Navigator.pop(builder);
                },
                child: const Text("確定"),
              )
            ],
            content: SizedBox(
                height: 200,
                child: CupertinoPicker(
                  itemExtent: 40,
                  onSelectedItemChanged: (int value) {
                    // options[value];
                    index = value;
                    handler(options[value]);
                  },
                  children: options.map((e) => Text(e)).toList(),
                )),
          ));
}
void medicationPasswordCheck(BuildContext context, Image? image,String error,void Function(String password) handler){
  TextEditingController controller = TextEditingController();
  showDialog(context:context,builder: (BuildContext builder) => AlertDialog (
    title: const Text('委託人密碼驗證'),
    actions: [
      TextButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.pop(builder);
        },
        child: const Text("取消"),
      ),
      TextButton(
        onPressed: () {
          handler(controller.text);
          Navigator.pop(builder);
        },
        child: const Text("確定"),
      )
    ],
    content: Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: image,
          ),
          Container(
            child: Text(error,style: const TextStyle(color: Colors.red),),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '請輸入密碼',
              ),
            ),
          ),
        ],
      )


    ),
  ));
}
void selectTime( BuildContext context,List<String> times, void Function(List<String> times) handler) {
  List<Map> timeList = [];
  for (var i = 0 ; i <= 23 ; i++){
    timeList.add({ 'time':'${i.toString().padLeft(2,'0')}:00' , 'check' : false});
    timeList.add({ 'time':'${i.toString().padLeft(2,'0')}:30' , 'check' : false});
  }
  for (var t in times) {
    for (var time in timeList) {
      if (time['time'] == t){
        time['check'] = true;
      }
    }
  }
  showDialog(
      context: context,
      builder: (BuildContext builder) => AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(builder);
                },
                child: const Text("確定"),
              )
            ],
            content:StatefulBuilder(
              builder: (BuildContext context , StateSetter setState){
                return SizedBox(
                  width: double.maxFinite,
                  height: 250,
                  child: ListView.builder(
                      itemCount: timeList.length,
                      itemExtent: 40,
                      itemBuilder: (BuildContext context, int index) {
                        Image? check = Image.asset('assets/images/tick_b.png');
                        if (!timeList[index]['check']){
                          check = null;
                        }
                        return ListTile(
                          onTap: (){
                            setState(() {
                              timeList[index]['check'] = !timeList[index]['check'];
                              if (timeList[index]['check']){
                                times.add(timeList[index]['time']);
                              }else{
                                times.remove(timeList[index]['time']);
                              }
                              handler(times);
                            });
                          },
                          title: Text(timeList[index]['time']),
                          trailing: SizedBox(
                            width: 20,
                            height: 20,
                            child: check,
                          ),

                        );
                      }),
                );
              },
            ),

          ));
}
// void showCDialog(BuildContext context,Image? image, String? show, void handler()) {
//
// showGeneralDialog(context: context, pageBuilder: (BuildContext context, Animation animation,
//     Animation secondaryAnimation){
//     return Center(
//       child: ,
//     );
// });
//
// }
// fun setTimeList(){
//
//   for (i in 0..23){
//
//     timeList.add(TimeCheck("${pad(i)}:00"))
//     timeList.add(TimeCheck("${pad(i)}:30"))
//   }
// }
