import 'lat_lng.dart';

class LocationModel {
  LatLngModel? latLng;

  LocationModel({this.latLng});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latLng: json['latLng'] == null
          ? null
          : LatLngModel.fromJson(json['latLng'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latLng': latLng?.toJson(),
    };
  }
}
