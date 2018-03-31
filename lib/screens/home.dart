import 'package:flutter/material.dart';

import 'package:movie_app/model/model.dart';
import 'package:movie_app/screens/movieView.dart';

import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

const key = '<API KEY HERE>';

class HomePage extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  List<Movie> movies = List();
  bool hasLoaded = true;

  final PublishSubject subject = PublishSubject<String>();

  @override
  void dispose() {
    subject.close();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    subject.stream.debounce(Duration(milliseconds: 400)).listen(searchMovies);
  }

  void searchMovies(query) {
    resetMovies();
    if (query.isEmpty) {
      setState(() {
        hasLoaded = true;
      });
      return;
    }
    setState(() => hasLoaded = false);
    http
        .get(
            'https://api.themoviedb.org/3/search/movie?api_key=$key&query=$query')
        .then((res) => (res.body))
        .then(json.decode)
        .then((map) => map["results"])
        .then((movies) => movies.forEach(addMovie))
        .catchError(onError)
        .then((e) {
      setState(() {
        hasLoaded = true;
      });
    });
  }

  void onError(dynamic d) {
    setState(() {
      hasLoaded = true;
    });
  }

  void addMovie(item) {
    setState(() {
      movies.add(Movie.fromJson(item));
    });
    print('${movies.map((m) => m.title)}');
  }

  void resetMovies() {
    setState(() => movies.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (String string) => (subject.add(string)),
            keyboardType: TextInputType.url,
          ),
          hasLoaded ? Container() : CircularProgressIndicator(),
          Expanded(
              child: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index) {
              return new MovieView(movies[index]);
            },
          ))
        ],
      ),
    );
  }
}
