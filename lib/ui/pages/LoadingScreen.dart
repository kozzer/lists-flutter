import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget{
  @override
  build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment:  MainAxisAlignment.center, 
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(48),
            child: Image(
              image: AssetImage('lib/assets/lists_icon.png'),
              width: 100,
              height: 150
            )
          ),
          SizedBox(
            child: CircularProgressIndicator(backgroundColor: Colors.green,),
            width: 24,
            height: 24,
          ),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Loading...', 
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                decoration: TextDecoration.none
                )
            )
          )
        ]
      )
    );
  }
}