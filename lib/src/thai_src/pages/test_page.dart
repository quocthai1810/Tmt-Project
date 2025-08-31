import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late bool isLoading;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    Future.delayed(Duration(seconds: 4)).then(
      (onValue) => setState(() {
        isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(listIcon: [], showLeading: true),
      // body: isLoading== true ? CustomLoading(width: 88, height: 88): Text("data"),
      body: Column(
        children: [
          // ElevatedButton(
          //   onPressed: () {
          //     OverlayLoading.show(context);
          //     Future.delayed(Duration(seconds: 4));
          //     OverlayLoading.hide();
          //   },
          //   child: Text("nhan vao"),
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     print("nhan vao di");
          //   },
          //   child: Text("print dang ki"),
          // ),
          // CustomItemHorizontal(
          //   imageUrl: "https://picsum.photos/id/1005/800/500",
          //   title: "Spider-Man No Way Home",
          //   stateMovies: "Đang chiếu",
          //   duration: 148,
          //   ageRating: "13+",
          //   genres: ["Action", "Movie"],
          //   rating: 4.5,
          // ),
        ],
      ),
    );
  }
}
