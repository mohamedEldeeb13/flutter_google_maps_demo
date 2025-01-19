class MatchedSubstring {
  int? length;
  int? offset;

  MatchedSubstring({this.length, this.offset});

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) {
    return MatchedSubstring(
      length: json['length'] as int?,
      offset: json['offset'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'offset': offset,
    };
  }
}
