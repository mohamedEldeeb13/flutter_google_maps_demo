import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_google_maps_demo/Models/location_info_model/lat_lng.dart';
import 'package:flutter_google_maps_demo/Models/location_info_model/location.dart';
import 'package:flutter_google_maps_demo/Models/location_info_model/location_info_model.dart';
import 'package:flutter_google_maps_demo/Models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:flutter_google_maps_demo/Models/place_details_model/place_details_model.dart';
import 'package:flutter_google_maps_demo/Models/routes_model/routes_model.dart';
import 'package:flutter_google_maps_demo/utilities/google_map_places_service.dart';
import 'package:flutter_google_maps_demo/utilities/location_service.dart';
import 'package:flutter_google_maps_demo/utilities/routes_service.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapServices {
  GoogleMapPlacesService placesService = GoogleMapPlacesService();
  LocationService locationService = LocationService();
  RoutesService routesService = RoutesService();
  LatLng? currentLocation;
  // bool hasDraggedMarker = false;
  bool isFirstCamera = false;
  Future<void> getPredictions(
      {required String input,
      required String sesstionToken,
      required List<PlaceAutocompleteModel> places}) async {
    if (input.isNotEmpty) {
      var result = await placesService.getPredictions(
          sesstionToken: sesstionToken, input: input);

      places.clear();
      places.addAll(result);
    } else {
      places.clear();
    }
  }

  Future<List<LatLng>> getRouteData({required LatLng desintation}) async {
    LocationInfoModel origin = LocationInfoModel(
      location: LocationModel(
          latLng: LatLngModel(
        latitude: currentLocation!.latitude,
        longitude: currentLocation!.longitude,
      )),
    );
    LocationInfoModel destination = LocationInfoModel(
      location: LocationModel(
          latLng: LatLngModel(
        latitude: desintation.latitude,
        longitude: desintation.longitude,
      )),
    );
    RoutesModel routes = await routesService.fetchRoutes(
        origin: origin, destination: destination);
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> points = getDecodedRoute(polylinePoints, routes);
    return points;
  }

  List<LatLng> getDecodedRoute(
      PolylinePoints polylinePoints, RoutesModel routes) {
    List<PointLatLng> result = polylinePoints.decodePolyline(
      routes.routes!.first.polyline!.encodedPolyline!,
    );

    List<LatLng> points =
        result.map((e) => LatLng(e.latitude, e.longitude)).toList();
    return points;
  }

  void displayRoute(List<LatLng> points,
      {required Set<Polyline> polyLines,
      required GoogleMapController googleMapController}) {
    Polyline route = Polyline(
      color: Colors.blue,
      width: 7,
      polylineId: const PolylineId('route'),
      points: points,
    );

    polyLines.add(route);
    LatLngBounds bounds = getLatLngBounds(points);
    googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 32));
  }

  LatLngBounds getLatLngBounds(List<LatLng> points) {
    var southWestLatitude = points.first.latitude;
    var southWestLongitude = points.first.longitude;
    var northEastLatitude = points.first.latitude;
    var northEastLongitude = points.first.longitude;

    for (var point in points) {
      southWestLatitude = min(southWestLatitude, point.latitude);
      southWestLongitude = min(southWestLongitude, point.longitude);
      northEastLatitude = max(northEastLatitude, point.latitude);
      northEastLongitude = max(northEastLongitude, point.longitude);
    }
    return LatLngBounds(
        southwest: LatLng(southWestLatitude, southWestLongitude),
        northeast: LatLng(northEastLatitude, northEastLongitude));
  }

  void updateCurrentLocation(
      {required GoogleMapController googleMapController,
      required Set<Marker> markers,
      required Function onUpdatecurrentLocation}) {
    locationService.getRealTimeLocationData((locationData) {
      // if (!hasDraggedMarker) {
      //   currentLocation =
      //       LatLng(locationData.latitude!, locationData.longitude!);
      // }
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      Marker currentLocationMarker = Marker(
        markerId: const MarkerId('my location'),
        position: currentLocation!,
      );
      if (!isFirstCamera) {
        CameraPosition myCurrentCameraPoistion = CameraPosition(
          target: currentLocation!,
          zoom: 17,
        );
        googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(myCurrentCameraPoistion));
        isFirstCamera = true;
      } else {
        googleMapController
            .animateCamera(CameraUpdate.newLatLng(currentLocation!));
      }
      markers.add(currentLocationMarker);
      onUpdatecurrentLocation();
    });
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    return await placesService.getPlaceDetails(placeId: placeId);
  }

  // New method for handling draggable marker for the current location
  // void setDraggableCurrentLocationMarker({
  //   required Set<Marker> markers,
  //   required GoogleMapController googleMapController,
  //   required Function(LatLng newLocation) onLocationUpdated,
  // }) {
  //   // Remove the existing current location marker
  //   markers.removeWhere(
  //       (marker) => marker.markerId == const MarkerId('my location'));
  //   // Add a new draggable marker for the current location
  //   if (currentLocation != null) {
  //     markers.add(
  //       Marker(
  //         markerId: const MarkerId('my location'),
  //         position: currentLocation!,
  //         draggable: true,
  //         onDragStart: (value) {
  //           hasDraggedMarker = true;
  //         },
  //         onDragEnd: (LatLng newPosition) {
  //           currentLocation = newPosition;
  //           onLocationUpdated(newPosition);
  //           // Optionally animate the camera to the new position
  //           googleMapController.animateCamera(
  //             CameraUpdate.newLatLng(newPosition),
  //           );
  //         },
  //       ),
  //     );
  //   }
  // }
}
