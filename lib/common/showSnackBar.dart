
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context , String show){
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(
    content: Text(show)
    ,behavior: SnackBarBehavior.floating,));
}