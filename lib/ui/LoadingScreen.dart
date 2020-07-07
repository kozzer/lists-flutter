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
            width: 60,
            height: 60,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('Loading Lists! data...'),
          )
        ]
      )
    );
  }
}