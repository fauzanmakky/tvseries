import 'package:flutter/material.dart';
import 'package:tvseries/approuter.dart';
import 'package:tvseries/commons/constants/api_constants.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tvseries',
      theme: ThemeData.dark().copyWith(
        colorScheme: kColorScheme,
        primaryColor: kRichBlack,
        scaffoldBackgroundColor: kRichBlack,
        textTheme: kTextTheme,
        drawerTheme: kDrawerTheme,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
