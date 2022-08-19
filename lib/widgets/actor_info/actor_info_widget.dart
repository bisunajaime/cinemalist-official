import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tmdbflutter/bloc/actors/actor_info_cubit.dart';
import 'package:tmdbflutter/models/actor_info_model.dart';
import 'package:tmdbflutter/styles/styles.dart';

class ActorInfoWidget extends StatelessWidget {
  const ActorInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ActorInfoCubit>();
    ActorInfoModel? actorInfoModel = cubit.state;
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
          cubit.loadActorInfo();
        },
        child: Icon(Icons.refresh),
      );
    }
    actorInfoModel!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  height: double.infinity,
                  margin: EdgeInsets.only(
                    left: 10,
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: (actorInfoModel?.profilePath == null
                            ? AssetImage('assets/images/placeholder_actor.png')
                            : NetworkImage(
                                'https://image.tmdb.org/t/p/w500${actorInfoModel!.profilePath}'))
                        as ImageProvider<Object>,
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                  )),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.all(5),
                  child: ListView(
                    children: <Widget>[
                      Text(
                        actorInfoModel.name!,
                        style: Styles.mBold.copyWith(
                          fontSize: 20,
                          color: Colors.pinkAccent[100],
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Birthplace",
                        style: Styles.mBold.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        actorInfoModel.placeOfBirth == "?"
                            ? "Not Specified"
                            : actorInfoModel.placeOfBirth!,
                        style: Styles.mReg.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Department",
                        style: Styles.mBold.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        actorInfoModel.knownForDepartment!,
                        style: Styles.mReg.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Birthday",
                        style: Styles.mBold.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        actorInfoModel.birthday == "?"
                            ? "Not Specified"
                            : DateFormat.yMMMd().format(
                                DateTime.tryParse(actorInfoModel.birthday!)!),
                        style: Styles.mReg.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Age",
                        style: Styles.mBold.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        actorInfoModel.birthday == "?"
                            ? "Not Specified"
                            : (DateTime.now().year -
                                    DateTime.parse(actorInfoModel.birthday!)
                                        .year)
                                .toString(),
                        style: Styles.mReg.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Status",
                        style: Styles.mBold.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        actorInfoModel.deathday == "?"
                            ? "Alive"
                            : actorInfoModel.deathday!,
                        style: Styles.mReg.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Popularity",
                        style: Styles.mBold.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        actorInfoModel.popularity.toString(),
                        style: Styles.mBold.copyWith(
                          fontSize: 10,
                          color: actorInfoModel.popularity > 5
                              ? Colors.greenAccent
                              : Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Divider(
          color: Colors.white,
          indent: 40.0,
          endIndent: 40.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Biography",
            style: Styles.mBold.copyWith(
              fontSize: 15,
              color: Colors.pinkAccent[100],
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            actorInfoModel.biography!.trim().length == 0
                ? 'Not Specified'
                : actorInfoModel.biography!,
            style: Styles.mReg.copyWith(
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}
