import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movie_app/models/moview_rating_response.dart';
import 'package:movie_app/models/title_by_genre_response.dart';
import 'package:movie_app/models/upcoming_movies_response.dart';

import '../api/api_response.dart';
import '../api/http_service.dart';
import '../utility/utility.dart';

class BrowseMovie extends StatefulWidget {
  const BrowseMovie({Key? key}) : super(key: key);

  @override
  _BrowseMovieState createState() => _BrowseMovieState();
}

class _BrowseMovieState extends State<BrowseMovie> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ApiResponse _apiResponseUpcomingMovies = ApiResponse();
  late ApiResponse _apiResponseTitlesByGenre = ApiResponse();
  final HttpService _httpService = HttpService();
  final List<Map<String, dynamic>> _images = [];
  final String defaultImage =
      'https://rukminim1.flixcart.com/image/416/416/poster/q/r/v/posterskart-interstellar-movie-poster-pkis04-medium-original-imaebctvytcgcgcx.jpeg?q=70';

  @override
  void initState() {
    _getUpcomingMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C5DD3),
        title: const Text(
          "Home",
        ),
      ),
      backgroundColor: const Color(0xFF1F2128),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15.0,
                      spreadRadius: 0,
                      offset: const Offset(0, 4))
                ],
                color: const Color(0xFF242731),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Upcoming Movies",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 220.0,
                enlargeCenterPage: true,
                onPageChanged: (position, reason) {},
                enableInfiniteScroll: false,
              ),
              items: _images.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Stack(
                      children: [
                        Container(
                          width: 400,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 15.0,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 4))
                              ],
                              color: const Color(0xFF242731),
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                  image: NetworkImage(i["url"]),
                                  fit: BoxFit.fill)),
                        ),
                        (i['url'] == defaultImage)
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6C5DD3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  i['title'],
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : const SizedBox()
                      ],
                    );
                  },
                );
              }).toList(),
            ),
            Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                margin:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15.0,
                        spreadRadius: 0,
                        offset: const Offset(0, 4))
                  ],
                  color: const Color(0xFF242731),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Text(
                      "Genre",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 25,
                      color: Colors.white,
                    )
                  ],
                )),
            getTitleListWidget('Action'),
            getTitleListWidget('Comedy'),
            getTitleListWidget('Drama'),
            getTitleListWidget('Horror'),
            getTitleListWidget('Mystery'),
            getTitleListWidget('Sci-Fi'),
            getTitleListWidget('Thriller')
          ],
        ),
      ),
    ));
  }

  Widget getTitleListWidget(String genre) {
    String rating = '6.8';
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15.0,
                spreadRadius: 0,
                offset: const Offset(0, 4))
          ],
          color: const Color(0xFF242731),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              genre,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            FutureBuilder<List<dynamic>>(
              future: _getMovieListByGenre(genre),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.only(top: 15),
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        (_getMovieRating(snapshot.data![index]['id']))
                            .then((value) {
                          rating = value;
                        });
                        return InkWell(
                          onTap: () {},
                          child: Container(
                              margin: const EdgeInsets.only(right: 20),
                              width: 120,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: NetworkImage(snapshot.data![index]
                                        ['primaryImage']['url']
                                    .toString()),
                                fit: BoxFit.cover,
                              )),
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    color: const Color(0xFF6C5DD3),
                                    child: Text(
                                      rating,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  )
                                ],
                              )),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ));
  }

  Future<List<Map<String, dynamic>>> _getMovieListByGenre(String genre) async {
    _apiResponseTitlesByGenre = await _httpService.getMoviewTitles(genre);
    final response =
        (_apiResponseTitlesByGenre.Data as TitlesByGenreResponse).toJson();

    final List<Map<String, dynamic>> result = [];

    if ((_apiResponseTitlesByGenre.Data as TitlesByGenreResponse).entries !=
        0) {
      for (var val in response['results']) {
        if (val['primaryImage'] != null) {
          result.add(val);
        }
        ;
      }

      return result;
    } else {
      Utility.showSnack('Could not fetch results', _scaffoldKey);
      throw Exception("Failed to load data");
    }
  }

  void _getUpcomingMovies() async {
    _apiResponseUpcomingMovies = await _httpService.getUpcomingMovies();

    final response =
        (_apiResponseUpcomingMovies.Data as UpcomingMoviesResponse).results;

    for (final result in response!) {
      if (result.primaryImage != null) {
        final imageUrl = result.primaryImage?.url;
        setState(() {
          _images.add({
            "url": imageUrl.toString(),
            "title": result.titleText?.text.toString()
          });
        });
      } else {
        setState(() {
          _images.add({
            "url": defaultImage,
            "title": result.titleText?.text.toString()
          });
        });
      }
    }
  }

  Future<String> _getMovieRating(String id) async {
    _apiResponseUpcomingMovies = await _httpService.getMoviewRating(id);

    final response =
        (_apiResponseUpcomingMovies.Data as MovieRatingResponse).results;

    print(response);

    if (response != null) {
      return response.averageRating.toString();
    } else {
      return '4.9';
    }
  }
}
