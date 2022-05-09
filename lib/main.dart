import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:orange_test/data/static/custom_colors.dart';
import 'package:orange_test/presentation/graph_screen/graph_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Orange Test',
        builder: (context, widget) =>
            ResponsiveWrapper.builder(const GraphScreen(),
                maxWidth: 2400,
                minWidth: 480,
                defaultScale: true,
                breakpoints: [
                  const ResponsiveBreakpoint.resize(480, name: MOBILE),
                  const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                ],
                backgroundColor: CustomColors.kPrimaryColor));
  }
}
