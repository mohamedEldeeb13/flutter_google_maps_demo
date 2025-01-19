import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_demo/Models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:flutter_google_maps_demo/Widgets/routeTracking/custom_list_view.dart';
import 'package:flutter_google_maps_demo/Widgets/routeTracking/custom_textfield.dart';
import 'package:flutter_google_maps_demo/utilities/location_service.dart';
import 'package:flutter_google_maps_demo/utilities/map_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class CustomRouteTracking extends StatefulWidget {
  const CustomRouteTracking({super.key});

  @override
  State<CustomRouteTracking> createState() => _CustomRouteTrackingState();
}

class _CustomRouteTrackingState extends State<CustomRouteTracking> {
  late CameraPosition intailCameraPosition;
  late GoogleMapController googleMapController;
  late MapServices mapServices;
  late TextEditingController textEditingController;
  late Uuid uuid;
  late LatLng destinationLocation;
  String? sesstionToken;
  List<PlaceAutocompleteModel> places = [];
  Set<Marker> mapMarkers = {};
  Set<Polyline> polyLines = {};
  bool isDestinationSet = false; // Track whether the destination is set

  Timer? debounce;

  @override
  void initState() {
    intailCameraPosition = const CameraPosition(target: LatLng(0, 0));
    mapServices = MapServices();
    textEditingController = TextEditingController();
    uuid = const Uuid();
    fetchPredictions();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  void fetchPredictions() {
    textEditingController.addListener(() async {
      if (debounce?.isActive ?? false) {
        debounce?.cancel();
      }
      debounce = Timer(const Duration(milliseconds: 100), () async {
        sesstionToken ??= uuid.v4();
        await mapServices.getPredictions(
            input: textEditingController.text,
            sesstionToken: sesstionToken!,
            places: places);
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: intailCameraPosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: mapMarkers,
          polylines: polyLines,
          onMapCreated: (controller) {
            googleMapController = controller;
            updateCurrentLocation();
          },
        ),
        Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                CustomTextField(textEditingController: textEditingController),
                const SizedBox(
                  height: 16,
                ),
                CustomListView(
                  places: places,
                  mapServices: mapServices,
                  onPlaceSelect: (placeDetailsModel) async {
                    textEditingController.clear();
                    places.clear();
                    FocusScope.of(context).unfocus();
                    sesstionToken = null;
                    destinationLocation = LatLng(
                        placeDetailsModel.geometry!.location!.lat!,
                        placeDetailsModel.geometry!.location!.lng!);
                    _setMarkerForDestination();
                    isDestinationSet = true;
                    var points = await mapServices.getRouteData(
                        desintation: destinationLocation);
                    mapServices.displayRoute(points,
                        polyLines: polyLines,
                        googleMapController: googleMapController);
                    setState(() {});
                  },
                )
              ],
            )),
      ],
    );
  }

  void updateCurrentLocation() async {
    try {
      mapServices.updateCurrentLocation(
          onUpdatecurrentLocation: () {
            // mapServices.setDraggableCurrentLocationMarker(
            //   markers: mapMarkers,
            //   googleMapController: googleMapController,
            //   onLocationUpdated: (LatLng newPosition) {
            //     // Trigger route update after location is updated
            //     if (isDestinationSet) {
            //       _updateRouteAfterLocationUpdate(googleMapController);
            //     }
            //     setState(() {});
            //   },
            // );
            // if (isDestinationSet) {
            //   _updateRouteAfterLocationUpdate(googleMapController);
            // }
            if (isDestinationSet) {
              _updateRouteAfterLocationUpdate(googleMapController);
            }
            setState(() {});
          },
          googleMapController: googleMapController,
          markers: mapMarkers);
    } on LocationServiceException catch (e) {
      debugPrint("location service exception $e");
    } on LocationPermissionException catch (e) {
      debugPrint("location permission exception $e");
    } catch (e) {
      debugPrint("$e");
    }
  }

  void _setMarkerForDestination() {
    // Add a marker for the destination location
    Marker destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: destinationLocation,
    );
    mapMarkers.add(destinationMarker);
  }

  Future<void> _updateRouteAfterLocationUpdate(
      GoogleMapController controller) async {
    if (mapServices.currentLocation != null) {
      var points = await mapServices.getRouteData(
        desintation: destinationLocation,
      );
      // Display the new route
      mapServices.displayRoute(
        points,
        polyLines: polyLines,
        googleMapController: controller,
      );
      setState(() {});
    }
  }
}

// create text field widget
// listen to the text field
// search places
// display results
// fetch place details from api
// take place details to route tracking view
// after fetch place details clear places list view and clear textfield
// generate session token
// store current location and destination location
// fetch list of routes 
// take first route because it is the best of routes
// decode string encodePolyLine to list of LatLong by flutter_polyline_points package
// display poly line  
