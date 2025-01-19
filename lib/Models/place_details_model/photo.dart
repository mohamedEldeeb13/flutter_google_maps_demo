class Photo {
  int? height;
  List<dynamic>? htmlAttributions;
  String? photoReference;
  int? width;

  Photo({
    this.height,
    this.htmlAttributions,
    this.photoReference,
    this.width,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      height: json['height'] as int?,
      htmlAttributions: (json['html_attributions'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      photoReference: json['photo_reference'] as String?,
      width: json['width'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'html_attributions': htmlAttributions,
      'photo_reference': photoReference,
      'width': width,
    };
  }
}
