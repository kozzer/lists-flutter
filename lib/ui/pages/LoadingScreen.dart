import 'package:flutter/material.dart';


class LoadingScreen extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 155, 160, 150),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: Container(),
              width: 64,
              height: 64
            ),
            Padding(
              padding: EdgeInsets.all(48),
              child:  Image(
                image: AssetImage('lib/assets/splash.png')
              )
            ), 
            SizedBox(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(const Color(0xFF00A800)),
                backgroundColor: const Color(0xFFA8A8A8),
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
