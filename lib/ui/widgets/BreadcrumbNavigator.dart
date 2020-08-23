import 'package:flutter/material.dart';
import 'package:lists/models/ListsNavigatorObserver.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:lists/models/RouteThing.dart';


class BreadCrumbNavigator extends StatelessWidget {
  final List<Route> currentRouteStack;

  BreadCrumbNavigator() : this.currentRouteStack = routeStack.toList();

  @override
  Widget build(BuildContext context) {
    final index     = (currentRouteStack?.length ?? 0) - 1;
    var   pageTitle = "Lists!";
    var   thingID   = 0;
    if (index >= 0){
      final currentRoute = currentRouteStack[index];
      final routeThing   = currentRoute.settings.arguments as RouteThing;
      if (routeThing != null){
        pageTitle = routeThing.title;
        thingID   = routeThing.thingID;
      }
    } 
    print('KOZZER - index: $index -- length: ${currentRouteStack?.length ?? 0} -- pageTitle: $pageTitle');                  
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[  
        GestureDetector(
          onTap: () {
            Navigator.popUntil(context,
              (popRoute) {
                final popRouteThing = popRoute.settings.arguments as RouteThing;

                print('KOZZER - popping down to main list, poproute: ${popRouteThing?.thingID} -- stack size: ${this.currentRouteStack.length}');

                return index < 0 
                        || popRouteThing == null 
                        || popRouteThing.thingID == 0;
              }
            );
          },
          child: Container(
            transform: Matrix4.translationValues(-4.0, 0.0, 0.0),
            //color: Color.fromARGB(255, 155, 155, 155),
            child: Padding(
              padding: EdgeInsets.only(right: 0.0),
              child:  Hero(
                tag: 'ListsAppIcon',
                child: Image(
                  image: AssetImage('lib/assets/splash.png'),
                  width: 32,
                  height: 32,
                )
              )
            )
          )
        ),   
        RowSuper(
          alignment: Alignment.centerLeft,
          fitHorizontally: true,
          innerDistance: -8,
          children: List<Widget>.from(currentRouteStack
            .asMap()
            .map(
              (index, value) => MapEntry(
                index,
                GestureDetector(
                  onTap: () {
                    Navigator.popUntil(context,
                      (popRoute) {
                        
                        if (index < 0) return true;

                        final popRouteThing   = popRoute.settings.arguments as RouteThing;
                        final indexRouteThing = currentRouteStack[index].settings.arguments as RouteThing;

                        print('KOZZER - poproute: ${popRouteThing.thingID} -- indexroute: ${indexRouteThing?.thingID} -- index: $index -- stack size: ${this.currentRouteStack.length}');

                        return popRouteThing?.thingID == indexRouteThing?.thingID
                                || (indexRouteThing?.thingID ?? 0) <= 0;
                      }
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        transform: Matrix4.translationValues(-2.0, 0.0, 0.0),
                        //color: Color.fromARGB(255, 128, 128, 128),
                        alignment: Alignment.centerLeft,
                        width: 18, 
                        child: Icon(
                          Icons.arrow_right, 
                          color: Theme.of(context).textTheme.bodyText1.color,
                          size: 24
                        )
                      ),
                      Container(
                        // transform: Matrix4.translationValues(-24.0, 0.0, 0.0),
                        child: _BreadButton(
                          currentRouteStack[index].settings.arguments as RouteThing,
                          index == 0
                        )
                      )
                    ],
                  )
                )
              ),
            )
            .values
          ),
        ),
        Hero(
          tag: 'thing$thingID-title', 
          child: Text(
            pageTitle, 
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14)
          )
        )
      ],
    );
  }
}

class _BreadButton extends StatelessWidget {
  final RouteThing routeThing;
  final bool isFirstButton;

  _BreadButton(this.routeThing, this.isFirstButton);

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Theme.of(context).primaryColor,
      //color: Color.fromARGB(255, 96, 96, 96),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start:  0, 
          end:    6, 
          top:    8, 
          bottom: 8
        ),
        child: Hero(tag: 'icon_thing${routeThing.thingID}', child: Icon(routeThing.icon, color: Theme.of(context).accentColor))
      ),
    );
  }
}
