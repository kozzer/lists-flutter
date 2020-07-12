import 'package:flutter/material.dart';

class SwipeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget> [ 
          Text(
            'Delete', 
            style: TextStyle(color: Theme.of(context).textTheme.headline1.color),
          ),
          Text(
            'Delete', 
            style: TextStyle(color: Theme.of(context).textTheme.headline1.color),
          ),          
        ]
      )
    );
  }
}