import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(48),
              child: Hero(
                tag: "lists_icon",
                child: Image(
                  image:  AssetImage('lib/assets/lists_icon.png'),
                  width:  192,
                  height: 192
                )
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
