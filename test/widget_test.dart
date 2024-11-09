// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reentry/core/util/graph_data.dart';

import 'package:reentry/main.dart';

void main() {

  test('testing time', (){
    final time = GraphData.randomDates;
    final generatedResult = GraphData().generateWeeklyDataForYAxis(time);
    print(generatedResult);
    expect(generatedResult, isNotEmpty);
  });
}
