import 'package:flutter/material.dart';






// https://medium.com/@Amir_P/implementing-breadcrumb-in-flutter-6ca9b8144206


// routeStack exists in global scope
List<Route> routeStack = List();

class ListsNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    routeStack.add(route);
    print('KOZZER - pushed route, stack size: ${routeStack.length}');
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    routeStack.remove(route);
    print('KOZZER - popped route, stack size: ${routeStack.length}');
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    super.didRemove(route, previousRoute);
    routeStack.remove(route);
    print('KOZZER - removed route, stack size: ${routeStack.length}');
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    final index = routeStack.indexOf(oldRoute);
    routeStack[index] = newRoute;
    print('KOZZER - replaced route, stack size: ${routeStack.length}');
  }
}