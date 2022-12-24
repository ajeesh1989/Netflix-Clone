import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix/application/downloads_bloc/downloads_bloc.dart';
import 'package:netflix/core/colors/colors.dart';
import 'package:netflix/core/constants.dart';
import 'package:netflix/presentation/widgets/appbar_widget.dart';

class ScreenDownload extends StatelessWidget {
  ScreenDownload({Key? key}) : super(key: key);

  final _widgetList = [
    const smartdownloads(),
    Section2(),
    const Section3(),
  ];
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SafeArea(
          child: AppBarWidget(
            title: "Downloads",
          ),
        ),
      ),
      body: ListView.separated(
          padding: EdgeInsets.all(7),
          itemCount: _widgetList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) => _widgetList[index]),
    );
  }
}

class Section2 extends StatelessWidget {
  Section2({Key? key}) : super(key: key);
  // final List movieposter = [
  //   'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/vNVFt6dtcqnI7hqa6LFBUibuFiw.jpg',
  //   "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/jqPGGx9XhFjLjb96ZbQ6eoMB4n2.jpg",
  //   "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg"
  // ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<DownloadsBloc>(context)
          .add(const DownloadsEvent.getDownloadsImage());
    });
    BlocProvider.of<DownloadsBloc>(context)
        .add(const DownloadsEvent.getDownloadsImage());
    final Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        const Text(
          "Introducing Downloads For You",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kwhitecolor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        kheight,
        const Text(
          'We will download a personalised selection of\nmovies and shows for you, so there is always\nsomething to watch on your device',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        kheight,
        BlocBuilder<DownloadsBloc, DownloadState>(
          builder: (context, state) {
            return SizedBox(
              width: size.width * 10,
              height: size.height * 0.5,
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: size.width * 0.4,
                          backgroundColor: Colors.grey.withOpacity(0.3),
                        ),
                        PosterImagewidget(
                          movieposter:
                              '$imageAppendUrl${state.downloads![0].posterPath}',
                          margin: const EdgeInsets.only(left: 130, top: 50),
                          angle: 25,
                          size: Size(size.width * 0.4, size.width * 0.58),
                        ),
                        PosterImagewidget(
                            movieposter:
                                '$imageAppendUrl${state.downloads![1].posterPath}',
                            margin: const EdgeInsets.only(right: 130, top: 50),
                            angle: -20,
                            radius: 5,
                            size: Size(size.width * 0.4, size.width * 0.58)),
                        PosterImagewidget(
                            movieposter:
                                '$imageAppendUrl${state.downloads![2].posterPath}',
                            radius: 8,
                            margin: const EdgeInsets.only(bottom: 10, top: 50),
                            size: Size(size.width * 0.4, size.width * 0.6)),
                      ],
                    ),
            );
          },
        ),
      ],
    );
  }
}

class Section3 extends StatelessWidget {
  const Section3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: MaterialButton(
              color: Colors.blue.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Set up",
                  style: TextStyle(
                    color: kwhitecolor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        ),
        MaterialButton(
            color: Colors.grey.shade800,
            onPressed: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "See what you can download",
                style: TextStyle(
                  color: kwhitecolor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
      ],
    );
  }
}

// ignore: camel_case_types
class smartdownloads extends StatelessWidget {
  const smartdownloads({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: const [
          Icon(
            Icons.settings,
            color: kwhitecolor,
          ),
          kwidth,
          Text(
            'Smart downloads',
          ),
        ],
      ),
    );
  }
}

class PosterImagewidget extends StatelessWidget {
  const PosterImagewidget(
      {Key? key,
      required this.movieposter,
      this.angle = 0,
      required this.margin,
      required this.size,
      this.radius = 10})
      : super(key: key);

  final double angle;
  final String movieposter;
  final EdgeInsets margin;
  final Size size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Transform.rotate(
        angle: angle * pi / 180,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(movieposter), fit: BoxFit.cover),
              color: kwhitecolor,
            ),
          ),
        ),
      ),
    );
  }
}
