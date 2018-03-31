import 'package:flutter/material.dart';
import 'package:movie_app/model/model.dart';
import 'package:movie_app/database/database.dart';

class MovieView extends StatefulWidget {
  MovieView(this.movie);
  final Movie movie;

  @override
  MovieViewState createState() => MovieViewState();
}

class MovieViewState extends State<MovieView> {
  Movie movieState;

  @override
  void initState() {
    super.initState();
    movieState = widget.movie;
    MovieDatabase db = MovieDatabase();
    db.getMovie(movieState.id).then((movie) {
      setState(() => movieState.favored = movie.favored);
    });
  }

  void onPressed() {
    MovieDatabase db = MovieDatabase();
    setState(() => movieState.favored = !movieState.favored);
    movieState.favored == true
        ? db.addMovie(movieState)
        : db.deleteMovie(movieState.id);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        initiallyExpanded: movieState.isExpanded ?? false,
        onExpansionChanged: (b) => movieState.isExpanded = b,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: RichText(
              text: TextSpan(
                text: movieState.overview,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          )
        ],
        leading: IconButton(
          icon: movieState.favored ? Icon(Icons.star) : Icon(Icons.star_border),
          color: Colors.white,
          onPressed: () {
            onPressed();
          },
        ),
        title: Container(
            height: 200.0,
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                movieState.posterPath != null
                    ? Hero(
                        child: Image.network(
                            "https://image.tmdb.org/t/p/w92${movieState.posterPath}"),
                        tag: movieState.id,
                      )
                    : Container(),
                Expanded(
                    child: Text(
                  movieState.title,
                  textAlign: TextAlign.center,
                  maxLines: 10,
                ))
              ],
            )));
  }
}
