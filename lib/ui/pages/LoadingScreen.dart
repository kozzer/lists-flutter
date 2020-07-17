import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class LoadingScreen extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(48),
              child:  Image(
                image: AssetImage('lib/assets/lists_icon.png')
              )
            ), 
            SizedBox(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              width: 24,
              height: 24,
            ),
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('Loading...',
                style: TextStyle(
                  fontSize: 16,
                  //color: Theme.of(context).textTheme.headline5.color,
                  decoration: TextDecoration.none
                )
              )
            )
          ]
        )
      )
    );
  }
}
