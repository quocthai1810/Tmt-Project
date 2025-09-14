import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:tmt_project/routers/app_route.dart';
import 'package:tmt_project/src/minh_src/pages/booking_ticket_pages/bookingProvider.dart';
import 'package:tmt_project/src/minh_src/pages/detail_pages/detailProvider.dart';
import 'package:tmt_project/src/minh_src/pages/trailer_pages/trailerProviders.dart';
import 'package:tmt_project/src/thai_src/pages/filter_page/filter_provider.dart';
import 'package:tmt_project/src/thai_src/pages/home_page/home_page_provider.dart';
import 'package:tmt_project/src/thai_src/pages/new_page/new_provider.dart';
import 'package:tmt_project/src/thai_src/pages/search_page/search_provider.dart';
import 'package:tmt_project/src/thai_src/pages/theater_page/theater_provider.dart';

///import
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi'); // để DateFormat.E('vi') hoạt động
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MovieProvider>(create: (_) => MovieProvider()),
        ChangeNotifierProvider<NewsProvider>(create: (_) => NewsProvider()),
        ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),
        ChangeNotifierProvider<FilterProvider>(create: (_) => FilterProvider()),
        ChangeNotifierProvider<TheaterProvider>(
          create: (_) => TheaterProvider(),
        ),
        ChangeNotifierProvider<Detailprovider>(create: (_) => Detailprovider()),
        ChangeNotifierProvider<CommentProvider>(
          create: (_) => CommentProvider(),
        ),
        ChangeNotifierProvider<TrailerProvider>(
          create: (_) => TrailerProvider(),
        ),
        ChangeNotifierProvider<CumRapProvider>(create: (_) => CumRapProvider()),
        ChangeNotifierProvider<LayRapPhimProvider>(
          create: (_) => LayRapPhimProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRouteNames.entryPointPage,
      routes: appRoutes,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        //Đây là màu Chủ đề cho app ( màu Hồng cho đời đẹp :)) )
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
    );
  }
}
