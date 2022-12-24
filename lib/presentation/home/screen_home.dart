import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix/application/homepage/homepage_bloc.dart';
import 'package:netflix/core/constants.dart';

import 'package:netflix/presentation/home/numbertitle.dart';

import 'package:netflix/presentation/widgets/main_title_card.dart';

import 'widget/backgroundcard.dart';

ValueNotifier<bool> scrollNotifier = ValueNotifier(true);

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<HomepageBloc>(context).add(const GetHomeScreenData());
    });
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: scrollNotifier,
        builder: (BuildContext context, index, _) {
          return NotificationListener<UserScrollNotification>(
            onNotification: ((notification) {
              final ScrollDirection direction = notification.direction;
              if (direction == ScrollDirection.reverse) {
                scrollNotifier.value = false;
              } else if (direction == ScrollDirection.forward) {
                scrollNotifier.value = true;
              }
              return true;
            }),
            child: Stack(
              children: [
                BlocBuilder<HomepageBloc, HomepageState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      );
                    } else if (state.hasError) {
                      return const Center(
                        child: Text(
                          'Error while loading',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    // release Past year
                    final _releasedPastyear = state.pastYearMovieList.map((m) {
                      return "$imageAppendUrl${m.posterPath}";
                    }).toList();
                    _releasedPastyear.shuffle();

                    //Trending Now
                    final _trending = state.treandingNowList.map((m) {
                      return "$imageAppendUrl${m.posterPath}";
                    }).toList();
                    //Tens dramas
                    final _tensDramas = state.tensDramasMovieList.map((m) {
                      return "$imageAppendUrl${m.posterPath}";
                    }).toList();
                    _tensDramas.shuffle();

                    //South Indian movies
                    final _southindian = state.southIndianMovieList.map((m) {
                      return "$imageAppendUrl${m.posterPath}";
                    }).toList();

                    //Top ten movies
                    final _topten = state.trendingtvList.map((m) {
                      return "$imageAppendUrl${m.posterPath}";
                    }).toList();

                    return ListView(
                      children: [
                        const BackgroundCard(),
                        MainTitleCard(
                          title: 'Released in the past year',
                          posterList: _releasedPastyear.sublist(0, 10),
                        ),
                        kheight,
                        MainTitleCard(
                          title: 'Trending Now',
                          posterList: _trending.sublist(0, 10),
                        ),
                        kheight,
                        NumberTitleCard(
                          postersList: _topten.sublist(0, 10),
                        ),
                        kheight,
                        MainTitleCard(
                          title: 'Tense Dramas ',
                          posterList: _tensDramas.sublist(0, 10),
                        ),
                        kheight,
                        MainTitleCard(
                          title: 'South Indian Cinema',
                          posterList: _southindian.sublist(0, 10),
                        ),
                        kheight,
                      ],
                    );
                  },
                ),
                scrollNotifier.value == true
                    ? AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        width: double.infinity,
                        height: 120,
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  "https://preview.redd.it/gj1t3nckxyx61.png?auto=webp&s=a0925041ccf11f7453ba4b27cfec24afa0f34594",
                                  width: 100,
                                  height: 100,
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.cast,
                                  color: Colors.white,
                                ),
                                kwidth,
                                Container(
                                  width: 25,
                                  height: 25,
                                  color: Colors.blue,
                                ),
                                kwidth,
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'TV Shows',
                                  style: khomeTitleText,
                                ),
                                Text(
                                  'Movies',
                                  style: khomeTitleText,
                                ),
                                Text(
                                  'Categories',
                                  style: khomeTitleText,
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    : kheight20
              ],
            ),
          );
        },
      ),
    );
  }
}
