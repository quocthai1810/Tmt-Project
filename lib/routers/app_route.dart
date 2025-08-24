import 'package:flutter/material.dart';
import 'package:tmt_project/src/thai_src/pages/entry_point_page.dart';
import 'package:tmt_project/src/thai_src/pages/home_page.dart';
import 'package:tmt_project/src/thai_src/pages/news_page.dart';
import 'package:tmt_project/src/thai_src/pages/test_page.dart';
import 'package:tmt_project/src/thai_src/pages/theater_page.dart';
import 'package:tmt_project/src/thai_src/pages/user_page.dart';
import 'package:tmt_project/src/minh_src/page_test_wid.dart';

class AppRouteNames {
  static const entryPointPage = '/entry';
  static const homePage = '/';
  static const theaterPage = '/theater';
  static const newsPage = '/news';
  static const userPage = '/user';
  static const testPage = '/test';
  static const pageTestWid = '/pageTestWid';
}

final Map<String, WidgetBuilder> appRoutes = {
  AppRouteNames.entryPointPage: (context) => EntryPointPage(),
  AppRouteNames.homePage: (context) => HomePage(),
  AppRouteNames.theaterPage: (context) => TheaterPage(),
  AppRouteNames.newsPage: (context) => NewsPage(),
  AppRouteNames.userPage: (context) => UserPage(),
  AppRouteNames.testPage: (context) => TestPage(),
  AppRouteNames.pageTestWid: (context) => const PageTestWid(),
};
