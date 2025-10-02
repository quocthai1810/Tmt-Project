import 'package:flutter/material.dart';
import 'package:tmt_project/src/minh_src/models/modelGhe.dart';
import 'package:tmt_project/src/minh_src/models/takeComboModel.dart';
import 'package:tmt_project/src/minh_src/pages/testComponent/testComponent.dart';
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

//========= Route của Minh =========
import 'package:tmt_project/src/minh_src/pages/booking_ticket_pages/booking_ticket_pages.dart';
import 'package:tmt_project/src/minh_src/pages/change_pay_ticket/change_pay_ticket.dart';
import 'package:tmt_project/src/minh_src/pages/detail_pages/detail_pages.dart';
import 'package:tmt_project/src/minh_src/pages/purchase_preview/purchase_preview_pages.dart';
import 'package:tmt_project/src/minh_src/pages/takeCombo/take_combo_pages.dart';
import 'package:tmt_project/src/minh_src/pages/takeSeat/take_seat_pages.dart';
import 'package:tmt_project/src/minh_src/pages/trailer_pages/trailer_pages.dart';
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

import 'package:tmt_project/src/minh_src/pages/check_bill_pages/checkBill_pages.dart';

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
  static const chooseSeat = '/chooseSeat';

  // ======== Route của Minh ========
  static const bookingTicketPages = '/bookingTicketPages';
  static const changePayTicket = '/changePayTicket';
  static const chooseSeatPage = '/chooseSeatPage';
  static const detailPages = '/detailPages';
  static const purchasePreviewPages = '/purchasePreviewPages';
  static const takeComboPages = '/takeComboPages';
  static const takeSeatPages = '/takeSeatPages';
  static const trailerPages = '/trailerPages';
  static const testComponent = '/testComponent';
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

  static const checkBillPages = '/check-bill';
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

  // ======== Route của Minh ========
  AppRouteNames.testComponent: (context) => const TicketTearVerticalDemo(),
  AppRouteNames.bookingTicketPages: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final dynamic rawId = args["movieId"];
    final int movieId = rawId is int ? rawId : int.tryParse("$rawId") ?? 0;
    final String movieTitle = (args["movieTitle"] ?? "").toString();
    final String posterUrl = (args["posterUrl"] ?? "").toString();

    return BookingTicketPages(
      movieId: movieId,
      movieTitle: movieTitle,
      poster: posterUrl,
      // poster dùng ở BookingTicketPages nếu anh muốn show
    );
  },
  AppRouteNames.changePayTicket: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ChangePayTicketArguments;

    return ChangePayTicket(
      movieTitle: args.movieTitle,
      theaterName: args.theaterName,
      receiveDate: args.receiveDate,
      showTime: args.showTime,
      selectedSeats: args.selectedSeats,
      selectedCombos: args.selectedCombos,
      poster: args.posterUrl, // ✅ thêm poster
    );
  },

  AppRouteNames.detailPages: (context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final movieId = args is int ? args : -1;
    return DetailPages(movieId: movieId);
  },
  AppRouteNames.purchasePreviewPages: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return PurchasePreviewPages(
      movieTitle: args['movieTitle'],
      theaterName: args['theaterName'],
      receiveDate: args['receiveDate'],
      showTime: args['showTime'],
      selectedSeats: (args['selectedSeats'] as List).cast<GheModel>(),
      selectedCombos: (args['selectedCombos'] as List).cast<ComboModel>(),
      poster: args['posterUrl'] ?? '',
    );
  },
  AppRouteNames.takeComboPages: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return TakeComboPages(
      theaterName: args['theaterName'] ?? '',
      receiveDate: args['receiveDate'] ?? '',
      movieTitle: args['movieTitle'] ?? 'Unknown Movie',
      showTime: args['showTime'] ?? 'Chưa chọn suất chiếu',
      selectedSeats: (args['selectedSeats'] as List).cast<GheModel>(),
      maHeThong: args['maHeThong'] ?? 0,
      poster: args['posterUrl'] ?? '', // ✅ thêm poster
    );
  },

  AppRouteNames.takeSeatPages: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as SeatPageArguments;

    return TakeSeatPages(
      movieTitle: args.movieTitle,
      theaterName: args.theaterName,
      receiveDate: args.receiveDate,
      showTime: args.showTime,
      maPhong: args.maPhong,
      maSuatChieu: args.maSuatChieu,
      maHeThong: args.maHeThong,
      poster: args.posterUrl, // ✅ thêm poster
    );
  },

  AppRouteNames.trailerPages: (context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final movieId = args is int ? args : -1;
    return TrailerPages(movieId: movieId);
  },

  AppRouteNames.aboutUsPage: (context) => const AboutUsPage(),
  AppRouteNames.createNewPasswordPage:
      (context) => const CreateNewPasswordPage(),
  AppRouteNames.editProfilePage: (context) => const EditProfilePage(),
  AppRouteNames.loginPage: (context) => const LoginPage(),
  AppRouteNames.loginSignInPage: (context) => const LoginSignInPage(),
  AppRouteNames.myTicketPage: (context) => const MyTicketPage(),
  AppRouteNames.privacyPolicyPage: (context) => const PrivacyPolicyPage(),
  AppRouteNames.resetPasswordPage: (context) => const ResetPasswordPage(),
  AppRouteNames.signupPage: (context) => const SignUpPage(),
  AppRouteNames.verificationPage: (context) => const VerificationPage(),

  AppRouteNames.checkBillPages: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return CheckbillPages(
      movieTitle: args['movieTitle'],
      theaterName: args['theaterName'],
      receiveDate: args['receiveDate'],
      showTime: args['showTime'],
      selectedSeats: (args['selectedSeats'] as List).cast<GheModel>(),
      selectedCombos: (args['selectedCombos'] as List).cast<ComboModel>(),
      poster: args['posterUrl'] ?? '', // ✅ thêm poster
    );
  },
};

class SeatPageArguments {
  final String movieTitle;
  final String theaterName;
  final String receiveDate;
  final String showTime;
  final int maPhong;
  final int maSuatChieu;
  final int maHeThong;
  final String posterUrl; // ✅ thêm poster

  SeatPageArguments({
    required this.movieTitle,
    required this.theaterName,
    required this.receiveDate,
    required this.showTime,
    required this.maPhong,
    required this.maSuatChieu,
    required this.maHeThong,
    required this.posterUrl,
  });
}

class ChangePayTicketArguments {
  final String movieTitle;
  final String theaterName;
  final String receiveDate;
  final String showTime;
  final List<GheModel> selectedSeats;
  final List<ComboModel> selectedCombos;
  final String posterUrl; // ✅ thêm poster

  ChangePayTicketArguments({
    required this.movieTitle,
    required this.theaterName,
    required this.receiveDate,
    required this.showTime,
    required this.selectedSeats,
    required this.selectedCombos,
    required this.posterUrl,
  });
}
