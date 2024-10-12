import 'package:flutter/cupertino.dart';
import 'package:reentry/core/routes/routes.dart';

class RouteMap{

  static Map<String,Widget> maps = {
    AppRoutes.calender: SizedBox(),
    AppRoutes.goals: SizedBox(),
    AppRoutes.progress: SizedBox(),
    AppRoutes.dailyActions: SizedBox(),
  };
}