import 'package:cinemalist/bloc/carousel/carousel_cubit.dart';
import 'package:cinemalist/main.dart';
import 'package:cinemalist/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarouselPage extends StatelessWidget {
  const CarouselPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CarouselCubit(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Color(0xff0F0D0E),
        body: CarouselBody(),
      ),
    );
  }
}

class CarouselBody extends StatefulWidget {
  const CarouselBody({Key? key}) : super(key: key);

  @override
  State<CarouselBody> createState() => _CarouselBodyState();
}

class _CarouselBodyState extends State<CarouselBody> {
  // int currentIndex = 0;
  final pageController = PageController();
  final carouselItems = <IntroCarouselModel>[
    IntroCarouselModel(
      svgName: 'intro_carousel_1.svg',
      label: 'Browse through trending\nmovies, actors, and tv\nshows',
    ),
    IntroCarouselModel(
      svgName: 'intro_carousel_2.svg',
      label: 'Save your favorites so you\ndon\'t forget',
    ),
    IntroCarouselModel(
      svgName: 'intro_carousel_3.svg',
      label: 'Tier your liked movies, tv\nshows, and actors',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final carouselCubit = context.watch<CarouselCubit>();
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (value) {
              carouselCubit.setPage(value);
            },
            itemCount: carouselItems.length,
            itemBuilder: (context, index) {
              final item = carouselItems[index];
              return CarouselWidget(
                item: item,
              );
            },
          ),
        ),
        Container(
          height: 200,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                    3,
                    (i) => Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: i == carouselCubit.state
                                ? Color(0xffFF4181)
                                : Color(0xff615858),
                            shape: BoxShape.circle,
                          ),
                        )),
              ),
              SizedBox(height: 8),
              Text(
                carouselItems[carouselCubit.state].label,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
        Container(
          height: 70,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 70,
                  child: TextButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('CAROUSEL_LOADED', true);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainPage(),
                          ));
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Color(0xff272727),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        )),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 70,
                  child: TextButton(
                    onPressed: () async {
                      if (carouselCubit.state == carouselItems.length - 1) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('CAROUSEL_LOADED', true);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainPage(),
                            ));
                        return;
                      }
                      pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Color(0xffFF4181),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        )),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CarouselWidget extends StatelessWidget {
  final IntroCarouselModel item;
  const CarouselWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      item.svgPath,
      width: double.infinity,
    );
  }
}

class IntroCarouselModel {
  final String svgName, label;

  String get svgPath => 'assets/svg/carousel/$svgName';

  IntroCarouselModel({
    required this.svgName,
    required this.label,
  });
}
