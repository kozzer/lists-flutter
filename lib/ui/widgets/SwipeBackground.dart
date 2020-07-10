import 'package:flutter/material.dart';

class SwipeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget> [ 
          Text(
            'Delete', 
            style: TextStyle(color: Colors.white),
          ),
          Text(
            'Delete', 
            style: TextStyle(color: Colors.white),
          ),          
        ]
      )
    );
  }
}