import 'package:flutter/material.dart';
import 'package:masonry/masonry/presentation/constants/palette.dart';
import 'package:masonry/masonry/presentation/pages/masonry_image_page.dart';
import 'package:masonry/masonry/providers/images/preview_image_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => PreviewImageProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: kDefaultTextColor,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: kDefaultTextColor),
        ),
        appBarTheme: AppBarTheme.of(context).copyWith(
            color: kDefaultBackgroundColor,
            iconTheme:
                IconTheme.of(context).copyWith(color: kDefaultTextColor)),
        backgroundColor: kDefaultBackgroundColor,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MasonryImagePage(),
    );
  }
}
