import 'package:flutter/material.dart';

final bodyDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors:[ 
      Colors.red,
      Colors.white,
      Colors.red
    ],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [
      0.1,
      0.5,
      1
    ]
    
    )
);
