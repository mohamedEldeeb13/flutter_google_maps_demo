import 'dart:convert';

import 'package:flutter_google_maps_demo/Models/location_info_model/location_info_model.dart';
import 'package:flutter_google_maps_demo/Models/routes_model/routes_model.dart';
import 'package:flutter_google_maps_demo/Models/routes_modifier.dart';
import 'package:http/http.dart' as http;

class RoutesService {
  final String baseUrl =
      'https://routes.googleapis.com/directions/v2:computeRoutes';
  final String apiKey = 'AIzaSyDryMle3LiaZn4JWxaA4BWHKE1oRVnY5og';
  Future<RoutesModel> fetchRoutes(
      {required LocationInfoModel origin,
      required LocationInfoModel destination,
      RoutesModifier? routesModifiers}) async {
    Uri url = Uri.parse(baseUrl);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask':
          'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline'
    };
    Map<String, dynamic> body = {
      "origin": origin.toJson(),
      "destination": destination.toJson(),
      "travelMode": "DRIVE",
      "routingPreference": "TRAFFIC_AWARE",
      "computeAlternativeRoutes": false,
      "routeModifiers": routesModifiers != null
          ? routesModifiers.toJson()
          : RoutesModifier().toJson(),
      "languageCode": "en-US",
      "units": "IMPERIAL"
    };

    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return RoutesModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('No routes found');
    }
  }
}
