import 'package:flutter/material.dart';
import 'package:tmt_project/src/minh_src/choose_seat_page.dart';
import 'package:tmt_project/src/minh_src/detail_movie_page.dart';
import 'package:tmt_project/src/minh_src/page_test_wid.dart';
import 'package:tmt_project/src/thai_src/pages/choose_theater.dart';
import 'package:tmt_project/src/thai_src/pages/entry_point_page.dart';
import 'package:tmt_project/src/thai_src/pages/filter_page/filter_page.dart';
import 'package:tmt_project/src/thai_src/pages/home_page/home_page.dart';
import 'package:tmt_project/src/thai_src/pages/new_page/news_page.dart';
import 'package:tmt_project/src/thai_src/pages/notification_page.dart';
import 'package:tmt_project/src/thai_src/pages/search_page/search_genre.dart';
import 'package:tmt_project/src/thai_src/pages/search_page/search_page.dart';
import 'package:tmt_project/src/thai_src/pages/showing_page.dart';
import 'package:tmt_project/src/thai_src/pages/test_page.dart';
import 'package:tmt_project/src/thai_src/pages/theater_page/theater_page.dart';
import 'package:tmt_project/src/thai_src/pages/upcoming_page.dart';
import 'package:tmt_project/src/thai_src/pages/user_page.dart';
import 'package:tmt_project/src/tin_src/pages/signup_page/signup_page.dart';

import '../src/tin_src/pages/about_us_page/about_us_page.dart';
import '../src/tin_src/pages/create_new_password_page/create_new_password_page.dart';
import '../src/tin_src/pages/edit_profile_page/edit_profile_page.dart';
import '../src/tin_src/pages/login_page/login_page.dart';
import '../src/tin_src/pages/login_signin_page/login_signin_page.dart';
import '../src/tin_src/pages/my_ticket_page/my_ticket_page.dart';
import '../src/tin_src/pages/privacy_policy_page/privacy_policy_page.dart';
import '../src/tin_src/pages/reset_password_page/reset_password_page.dart';
import '../src/tin_src/pages/verification_page/verification_page.dart';
import '../src/tin_src/splash_screen.dart';

class AppRouteNames {
  static const splash = '/splash';
  static const entryPointPage = '/entry';
  static const homePage = '/';
  static const theaterPage = '/theater';
  static const newsPage = '/news';
  static const userPage = '/user';
  static const testPage = '/test';
  static const filterPage = '/filter';
  static const searchGenrePage = '/searchGenre';
  static const searchPage = '/search';
  static const notificationPage = '/notification';
  static const upcomingPage = '/upcoming';
  static const showingPage = '/showing';
  static const pageTestWid = '/pageTestWid';
  static const chooseTheater = '/chooseTheater';
  static const detailMovie = '/detailMovie';
  static const chooseSeat = '/chooseSeat';
  static const aboutUsPage = '/aboutUs';
  static const createNewPasswordPage = '/createNewPassword';
  static const editProfilePage = '/editProfile';
  static const loginPage = '/login';
  static const loginSignInPage = '/loginSignin';
  static const myTicketPage = '/myTicket';
  static const ticketCardPage = '/ticketCard';
  static const privacyPolicyPage = '/privacyPolicy';
  static const resetPasswordPage = '/resetPassword';
  static const signupPage = '/signup';
  static const verificationPage = '/verification';
}

final Map<String, WidgetBuilder> appRoutes = {
  AppRouteNames.splash: (context) => const SplashScreen(),
  AppRouteNames.entryPointPage: (context) => EntryPointPage(),
  AppRouteNames.homePage: (context) => HomePage(),
  AppRouteNames.theaterPage: (context) => TheaterPage(),
  AppRouteNames.newsPage: (context) => NewsPage(),
  AppRouteNames.userPage: (context) => UserPage(),
  AppRouteNames.testPage: (context) => TestPage(),
  AppRouteNames.filterPage: (context) => FilterPage(),
  AppRouteNames.searchGenrePage: (context) => SearchGenre(),
  AppRouteNames.searchPage: (context) => SearchPage(),
  AppRouteNames.notificationPage: (context) => NotificationPage(),
  AppRouteNames.upcomingPage: (context) => UpcomingMoviesPage(),
  AppRouteNames.showingPage: (context) => ShowingMoviesPage(),
  AppRouteNames.chooseTheater: (context) => ChooseTheater(),
  AppRouteNames.pageTestWid: (context) => const PageTestWid(),
  AppRouteNames.detailMovie: (context) => const DetailMoviePage(),
  AppRouteNames.chooseSeat: (context) => const ChooseSeatPage(),
  AppRouteNames.aboutUsPage: (context) => const AboutUsPage(),
  AppRouteNames.createNewPasswordPage: (context) => const CreateNewPasswordPage(),
  AppRouteNames.editProfilePage: (context) => const EditProfilePage(),
  AppRouteNames.loginPage: (context) => const LoginPage(),
  AppRouteNames.loginSignInPage: (context) => const LoginSignInPage(),
  AppRouteNames.myTicketPage: (context) => const MyTicketPage(),
  AppRouteNames.privacyPolicyPage: (context) => const PrivacyPolicyPage(),
  AppRouteNames.resetPasswordPage: (context) => const ResetPasswordPage(),
  AppRouteNames.signupPage: (context) => const SignUpPage(),
  AppRouteNames.verificationPage: (context) => const VerificationPage(),
};
