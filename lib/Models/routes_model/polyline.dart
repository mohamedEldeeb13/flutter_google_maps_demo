class Polyline {
  String? encodedPolyline;

  Polyline({this.encodedPolyline});

  factory Polyline.fromJson(Map<String, dynamic> json) {
    return Polyline(
      encodedPolyline: json['encodedPolyline'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'encodedPolyline': encodedPolyline,
    };
  }
}
