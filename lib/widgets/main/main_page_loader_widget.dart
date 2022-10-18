import 'package:cinemalist/main.dart';
import 'package:cinemalist/views/carousel_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PageToLoad {
  introCarousel,
  homePage,
}

class MainPageLoader extends StatefulWidget {
  const MainPageLoader({Key? key}) : super(key: key);

  @override
  State<MainPageLoader> createState() => _MainPageLoaderState();
}

class _MainPageLoaderState extends State<MainPageLoader> {
  bool loading = true;
  late PageToLoad pageToLoad;
  @override
  void initState() {
    super.initState();
    loadPage();
  }

  Future<void> loadPage() async {
    final prefs = await SharedPreferences.getInstance();
    final carouselLoaded = prefs.getBool('CAROUSEL_LOADED');
    if (carouselLoaded == true) {
      pageToLoad = PageToLoad.homePage;
    } else {
      pageToLoad = PageToLoad.introCarousel;
    }
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Container();
    switch (pageToLoad) {
      case PageToLoad.homePage:
        return MainPage();
      case PageToLoad.introCarousel:
        return CarouselPage();
      default:
        return Container();
    }
  }
}
