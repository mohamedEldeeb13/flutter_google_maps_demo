import 'dart:convert';

import 'package:flutter_google_maps_demo/Models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:flutter_google_maps_demo/Models/place_details_model/place_details_model.dart';
import 'package:http/http.dart' as http;

class GoogleMapPlacesService {
  final baseUrl = "https://maps.googleapis.com/maps/api/place";
  final apiKey = "AIzaSyDryMle3LiaZn4JWxaA4BWHKE1oRVnY5og";

  Future<List<PlaceAutocompleteModel>> getPredictions(
      {required String input, required String sesstionToken}) async {
    var response = await http.get(Uri.parse(
        "$baseUrl/autocomplete/json?key=$apiKey&input=$input&sessiontoken=$sesstionToken'"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)["predictions"];
      List<PlaceAutocompleteModel> places = [];
      for (var item in data) {
        places.add(PlaceAutocompleteModel.fromJson(item));
      }
      return places;
    } else {
      throw Exception();
    }
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    var response = await http
        .get(Uri.parse("$baseUrl/details/json?key=$apiKey&place_id=$placeId"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)["result"];
      return PlaceDetailsModel.fromJson(data);
    } else {
      throw Exception();
    }
  }
}
