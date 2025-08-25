import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';

class ShowingMoviesPage extends StatefulWidget {
  const ShowingMoviesPage({super.key});

  @override
  State<ShowingMoviesPage> createState() => _ShowingMoviesPageState();
}

class _ShowingMoviesPageState extends State<ShowingMoviesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        textTitle: "Phim đang chiếu",
        listIcon: [],
        showLeading: true,
      ),
    );
  }
}
