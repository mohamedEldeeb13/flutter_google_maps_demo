import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_maps_demo/Models/map_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition intailCameraPosition;
  late GoogleMapController googleMapController;
  String nightMapStyle = "";
  Set<Marker> mapMarkers = {};
  Set<Polyline> mapPolyLines = {};
  Set<Polygon> mapPolyGons = {};
  Set<Circle> mapCircles = {};

  @override
  void initState() {
    intailCameraPosition = const CameraPosition(
        target: LatLng(31.223143665392577, 29.976460680822758), zoom: 12);
    initMapStyle();
    initMarker();
    initPolyLines();
    initPolyGons();
    initKosharyAboTarekCircle();
    super.initState();
  }

  void initMapStyle() async {
    // 1 - load style data
    nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString("assets/map_style/map_style.json");
    setState(() {});
  }

  Future<Uint8List> getImageFromRawData(String image, double width) async {
    // convert image to raw data
    var imageData = await rootBundle.load(image);
    // convert raw data as unit8List and this step that make occure on with
    var imageCoder = await ui.instantiateImageCodec(
        imageData.buffer.asUint8List(),
        targetWidth: width.round());
    // get image data with new frame
    var imageFramInfo = await imageCoder.getNextFrame();
    // convert image to byte by png formate
    var imageByteData =
        await imageFramInfo.image.toByteData(format: ui.ImageByteFormat.png);
    // return to formate that can use it in marker
    return imageByteData!.buffer.asUint8List();
  }

  void initMarker() async {
    BitmapDescriptor customMarker = BitmapDescriptor.bytes(
        await getImageFromRawData("assets/images/location.png", 30));
    var myMarkers = places
        .map((element) => Marker(
            icon: customMarker,
            markerId: MarkerId(element.markerId.toString()),
            position: element.latLng,
            infoWindow: InfoWindow(title: element.name)))
        .toSet();
    mapMarkers.addAll(myMarkers);
    // add set state to show custom icon marker because if not add set state marker show with default state because custom icon take time to init so use set state to rebuild when custom icon is init
    setState(() {});
  }

  void initPolyLines() async {
    Polyline polyLine1 = const Polyline(
        polylineId: PolylineId("1"),
        zIndex: 1,
        points: [
          LatLng(31.183653760185607, 29.91296607712695),
          LatLng(31.257399661625026, 30.21232940384145)
        ],
        color: Colors.red,
        width: 5,
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        patterns: [PatternItem.dot]);

    Polyline polyLine2 = const Polyline(
        polylineId: PolylineId("2"),
        zIndex: 2,
        points: [
          LatLng(31.306979358524593, 30.0549212043084),
          LatLng(31.162605198217882, 30.07837244862418)
        ],
        color: Colors.blue,
        width: 5,
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap);
    mapPolyLines.add(polyLine1);
    mapPolyLines.add(polyLine2);
  }

  void initPolyGons() {
    Polygon polygon1 = Polygon(
        strokeWidth: 3,
        fillColor: Colors.green.withOpacity(0.3),
        polygonId: const PolygonId("1"),
        points: const [
          LatLng(31.1441415000658, 29.856523673284208),
          LatLng(31.159795736188617, 29.991602840543088),
          LatLng(31.24925617059012, 29.98128429304415),
        ]);
    mapPolyGons.add(polygon1);
  }

  void initKosharyAboTarekCircle() {
    Circle kosharyAboTarekCircle = const Circle(
        circleId: CircleId("1"),
        center: LatLng(31.202903549635543, 29.946489742923948),
        radius: 1000);
    mapCircles.add(kosharyAboTarekCircle);
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: intailCameraPosition,
          onMapCreated: (controller) {
            googleMapController = controller;
          },
          zoomControlsEnabled: false,
          style: nightMapStyle,
          markers: mapMarkers,
          polylines: mapPolyLines,
          polygons: mapPolyGons,
          circles: mapCircles,
          // zoomControlsEnabled: false,
          // cameraTargetBounds: CameraTargetBounds(LatLngBounds(
          //     southwest: LatLng(31.00593217989744, 29.824583158723232),
          //     northeast: LatLng(31.17866174097435, 30.400038351709917))),
        ),
        Positioned(
            bottom: 1,
            left: 16,
            right: 16,
            child: ElevatedButton(
                onPressed: () {
                  googleMapController.animateCamera(CameraUpdate.newLatLng(
                      const LatLng(30.789305448023512, 30.78933982101063)));
                  setState(() {});
                },
                child: const Text("Change location")))
      ],
    );
  }
}
