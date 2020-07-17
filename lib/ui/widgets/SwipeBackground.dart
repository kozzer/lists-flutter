import 'package:flutter/material.dart';

class SwipeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget> [ 
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(
              IconData(
                59691, 
                fontFamily: 'MaterialIcons'
              ), 
              color: Theme.of(context).textTheme.headline1.color
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              IconData(
                59691, 
                fontFamily: 'MaterialIcons'
              ), 
              color: Theme.of(context).textTheme.headline1.color
            ),
          )      
        ]
      )
    );
  }
}