// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapModel {
  String markerId, name;
  LatLng latLng;

  MapModel({
    required this.markerId,
    required this.name,
    required this.latLng,
  });
}

List<MapModel> places = [
  MapModel(
      markerId: "1",
      name: "مركز خليج القصب الصحي",
      latLng: const LatLng(31.092617235994197, 30.19762487011511)),
  MapModel(
      markerId: "2",
      name: "منحني خطر",
      latLng: const LatLng(31.099281112170434, 30.204365518196564)),
  MapModel(
      markerId: "3",
      name: "عزبة الملقة",
      latLng: const LatLng(31.10416744513966, 30.208852130409532))
];
