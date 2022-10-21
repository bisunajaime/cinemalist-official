import 'package:cinemalist/utils/poster_path_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cinemalist/bloc/actors/actor_info_cubit.dart';
import 'package:cinemalist/models/actor_info_model.dart';
import 'package:cinemalist/styles/styles.dart';

class ActorInfoWidget extends StatelessWidget {
  const ActorInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ActorInfoCubit>();
    final actorInfoModel = cubit.state;
    if (cubit.loading) {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.all(5),
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.pinkAccent[100],
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xff2e2e2e),
            ),
          ),
        ),
      );
    }
    if (cubit.error) {
      return GestureDetector(
        onTap: () {
          cubit.loadFromServer();
        },
        child: Icon(Icons.refresh),
      );
    }
    actorInfoModel!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 30),
        Container(
          width: MediaQuery.of(context).size.height * .2,
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: actorInfoModel.hasProfilePic
                ? Image.network(
                    PosterPathHelper.generatePosterPath(
                        actorInfoModel.profilePath),
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/placeholder_actor.png',
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        SizedBox(height: 15),
        Divider(
          color: Colors.white,
          indent: 40.0,
          endIndent: 40.0,
        ),
        SizedBox(height: 15),
        ActorDetailsWidget(actorInfoModel: actorInfoModel),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Biography",
            style: Styles.mBold.copyWith(
              fontSize: 24,
            ),
          ),
        ),
        SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            actorInfoModel.biography!.trim().length == 0
                ? 'Not Specified'
                : actorInfoModel.biography!,
            textAlign: TextAlign.center,
            style: Styles.mReg.copyWith(
              fontSize: 14,
              color: Colors.white.withOpacity(.75),
            ),
          ),
        ),
      ],
    );
  }
}

class ActorDetailsWidget extends StatelessWidget {
  final ActorInfoModel actorInfoModel;
  const ActorDetailsWidget({Key? key, required this.actorInfoModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              ActorDetailWidget(
                label: 'Age',
                content: actorInfoModel.age,
              ),
              SizedBox(width: 6),
              ActorDetailWidget(
                label: 'Department',
                content: actorInfoModel.knownForDepartment!,
              ),
              SizedBox(width: 6),
              ActorDetailWidget(
                label: 'Status',
                content: actorInfoModel.status,
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              ActorDetailWidget(
                label: 'Birthplace',
                content: actorInfoModel.placeOfBirth == null
                    ? "Not Specified"
                    : actorInfoModel.placeOfBirth!,
              ),
              SizedBox(width: 6),
              ActorDetailWidget(
                label: 'Birthday',
                content: actorInfoModel.dateOfBirth,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ActorDetailWidget extends StatelessWidget {
  final String label;
  final String content;
  const ActorDetailWidget({
    Key? key,
    required this.label,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff181818),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              content,
              maxLines: 1,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
