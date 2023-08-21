class MovieRatingResponse {
  Results? results;

  MovieRatingResponse({this.results});

  MovieRatingResponse.fromJson(Map<String, dynamic> json) {
    results =
        json['results'] != null ? Results.fromJson(json['results']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results?.toJson();
    }
    return data;
  }
}

class Results {
  String? tconst;
  double? averageRating;
  int? numVotes;

  Results({this.tconst, this.averageRating, this.numVotes});

  Results.fromJson(Map<String, dynamic> json) {
    tconst = json['tconst'];
    averageRating = json['averageRating'];
    numVotes = json['numVotes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tconst'] = tconst;
    data['averageRating'] = averageRating;
    data['numVotes'] = numVotes;
    return data;
  }
}
