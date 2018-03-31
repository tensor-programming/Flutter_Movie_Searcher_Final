import 'package:meta/meta.dart';

class Movie {
  Movie({
    @required this.title,
    @required this.posterPath,
    @required this.id,
    @required this.overview,
    this.favored,
    this.isExpanded,
  });

  String title, posterPath, id, overview;
  bool favored, isExpanded;

  Movie.fromJson(Map json)
      : title = json["title"],
        posterPath = json["poster_path"],
        id = json["id"].toString(),
        overview = json["overview"],
        favored = false;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['poster_path'] = posterPath;
    map['overview'] = overview;
    map['favored'] = favored;
    return map;
  }

  Movie.fromDb(Map map)
      : title = map["title"],
        posterPath = map["poster_path"],
        id = map["id"].toString(),
        overview = map["overview"],
        favored = map['favored'] == 1 ? true : false;
}
