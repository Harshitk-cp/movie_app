import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

import '../models/moview_rating_response.dart';
import '../models/title_by_genre_response.dart';
import '../models/upcoming_movies_response.dart';
import '../utility/constants.dart';
import 'api_error.dart';
import 'api_response.dart';

class HttpService {
  final String baseUrl = ApiConstants.BASE_URL;

  final headers = {
    'Content-Type': 'application/json',
    'Charset': 'utf-8',
    "Connection": "Keep-Alive",
    "X-RapidAPI-Key": ApiConstants.API_KEY,
  };

  Future<ApiResponse> getUpcomingMovies() async {
    ApiResponse apiResponse = ApiResponse();

    try {
      Response res =
          await get(Uri.parse('$baseUrl/titles/x/upcoming'), headers: headers);

      switch (res.statusCode) {
        case 200:
          apiResponse.Data =
              UpcomingMoviesResponse.fromJson(json.decode(res.body));
          break;
        case 400:
          apiResponse.ApiError = ApiError.fromJson(json.decode(res.body));
          break;
        default:
          apiResponse.ApiError = ApiError.fromJson(json.decode(res.body));
          break;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> getMoviewTitles(String genre) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      final uri = Uri.parse('$baseUrl/titles')
          .replace(queryParameters: {'genre': genre});
      Response res = await get(uri, headers: headers);

      switch (res.statusCode) {
        case 200:
          apiResponse.Data =
              TitlesByGenreResponse.fromJson(json.decode(res.body));
          break;
        case 400:
          apiResponse.ApiError = ApiError.fromJson(json.decode(res.body));
          break;
        default:
          apiResponse.ApiError = ApiError.fromJson(json.decode(res.body));
          break;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> getMoviewRating(String id) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      Response res =
          await get(Uri.parse('$baseUrl/titles/$id/ratings'), headers: headers);

      switch (res.statusCode) {
        case 200:
          apiResponse.Data =
              MovieRatingResponse.fromJson(json.decode(res.body));
          break;
        case 400:
          apiResponse.ApiError = ApiError.fromJson(json.decode(res.body));
          break;
        default:
          apiResponse.ApiError = ApiError.fromJson(json.decode(res.body));
          break;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    }
    return apiResponse;
  }
}
