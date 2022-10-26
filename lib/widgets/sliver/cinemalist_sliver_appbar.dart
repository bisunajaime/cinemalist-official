import 'package:cinemalist/styles/styles.dart';
import 'package:flutter/material.dart';

class CinemalistSliverAppBar extends StatelessWidget {
  final String topText;
  final String bottomText;
  final Widget body;
  const CinemalistSliverAppBar(
      {Key? key,
      required this.body,
      required this.topText,
      required this.bottomText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: Color(0xff0E0E0E),
            automaticallyImplyLeading: false,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * .2,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              stretchModes: [StretchMode.blurBackground],
              collapseMode: CollapseMode.parallax,
              title: Align(
                alignment: Alignment.bottomLeft,
                child: buildTitle(),
              ),
              background: Container(
                color: Color(0xff0E0E0E),
              ),
            ),
          )
        ];
      },
      body: body,
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.only(
        left: 10,
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            topText,
            style: Styles.mBold.copyWith(
              color: Colors.pinkAccent,
              fontSize: 10,
            ),
          ),
          Text(
            bottomText,
            style: Styles.mBold.copyWith(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
