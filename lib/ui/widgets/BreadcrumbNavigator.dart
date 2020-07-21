import 'package:flutter/material.dart';
import 'package:lists/models/ListsNavigatorObserver.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

class BreadCrumbNavigator extends StatelessWidget {
  final List<Route> currentRouteStack;

  BreadCrumbNavigator() : this.currentRouteStack = routeStack.toList();

  @override
  Widget build(BuildContext context) {
    return RowSuper(
      children: List<Widget>.from(currentRouteStack
          .asMap()
          .map(
            (index, value) => MapEntry(
                index,
                GestureDetector(
                    onTap: () {
                      Navigator.popUntil(context,
                          (route) => route == currentRouteStack[index]);
                    },
                    child: _BreadButton(
                        currentRouteStack[index].settings.arguments as IconData,
                        index == 0))),
          )
          .values),
      mainAxisSize: MainAxisSize.max,
      innerDistance: -16,
    );
  }
}

class _BreadButton extends StatelessWidget {
  final IconData icon;
  final bool isFirstButton;

  _BreadButton(this.icon, this.isFirstButton);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _TriangleClipper(!isFirstButton),
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start:  isFirstButton ? 8 : 20, 
            end:    28, 
            top:    8, 
            bottom: 8
          ),
          child: Icon(icon, color: Theme.of(context).accentColor)
        ),
      ),
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  final bool twoSideClip;

  _TriangleClipper(this.twoSideClip);

  @override
  Path getClip(Size size) {
    final Path path = new Path();
    if (twoSideClip) {
      path.moveTo(20, 0.0);
      path.lineTo(0.0, size.height / 2);
      path.lineTo(20, size.height);
    } else {
      path.lineTo(0, size.height);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - 20, size.height / 2);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}