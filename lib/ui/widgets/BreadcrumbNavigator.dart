import 'package:flutter/material.dart';
import 'package:lists/models/ListsNavigatorObserver.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:lists/models/RouteThing.dart';
import 'package:flutter_svg/flutter_svg.dart';


class BreadCrumbNavigator extends StatelessWidget {
  final List<Route> currentRouteStack;

  BreadCrumbNavigator() : this.currentRouteStack = routeStack.toList();

  @override
  Widget build(BuildContext context) {
    final index = (currentRouteStack?.length ?? 0) - 1;
    var pageTitle = "Lists!";
    var thingID = 0;
    if (index >= 0){
      final currentRoute = currentRouteStack[index];
      final routeThing = currentRoute.settings.arguments as RouteThing;
      if (routeThing != null){
        pageTitle = routeThing.title;
        thingID = routeThing.thingID;
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

                return popRouteThing == null || popRouteThing.thingID == 0;
              }
            );
          },
          child: Container(
            transform: Matrix4.translationValues(-4.0, 0.0, 0.0),
            child: Padding(
              padding: EdgeInsets.only(right: 4),
              child: SvgPicture.asset('lib/assets/lists.svg', width: 32, height: 32,)
            )
          )
        ),   
        RowSuper(
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
                        final popRouteThing   = popRoute.settings.arguments as RouteThing;
                        final indexRouteThing = currentRouteStack[index].settings.arguments as RouteThing;

                        print('KOZZER - poproute: ${popRouteThing.thingID} -- indexroute: ${indexRouteThing?.thingID} -- index: $index -- stack size: ${this.currentRouteStack.length}');

                        return popRouteThing?.thingID == indexRouteThing?.thingID
                                || (indexRouteThing?.thingID ?? 0) <= 0;
                      }
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 15, child: Icon(Icons.arrow_right, color: Theme.of(context).textTheme.bodyText1.color)),
                      _BreadButton(
                        currentRouteStack[index].settings.arguments as RouteThing,
                        index == 0
                      )
                    ],
                  )
                )
              ),
            )
            .values
          ),
        ),
        Hero(tag: 'thing$thingID-title', child: Text(pageTitle, style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14)))
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
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start:  16, 
          end:    8, 
          top:    8, 
          bottom: 8
        ),
        child: Hero(tag: 'icon_thing${routeThing.thingID}', child: Icon(routeThing.icon, color: Theme.of(context).accentColor))
      ),
    );
  }
}
