import 'package:flutter/material.dart';
import 'package:flutter_google_maps_demo/Widgets/custom_google_map.dart';
import 'package:flutter_google_maps_demo/Widgets/routeTracking/custom_route_tracking.dart';

void main() {
  runApp(const GoogleMapView());
}

class GoogleMapView extends StatelessWidget {
  const GoogleMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: CustomGoogleMap(),
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(child: CustomRouteTracking())),
    );
  }
}
