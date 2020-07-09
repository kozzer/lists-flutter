import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget{
  @override
  build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment:  MainAxisAlignment.center, 
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: CircularProgressIndicator(),
            width: 40,
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text('Loading...'),
          )
        ]
      )
    );
  }
}