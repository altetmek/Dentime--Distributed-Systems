class Coordinate {
  String _id;
  double latitude;
  double longitude;

  Coordinate({String id, double latitude, double longitude}) {
    this._id = id;
    this.latitude = latitude;
    this.longitude = longitude;
  }

  factory Coordinate.fromJson(Map<String, dynamic> parsedJson) {
    return Coordinate(
      id: parsedJson['_id'].toString(),
      latitude: double.parse(parsedJson['latitude'].toString()),
      longitude: double.parse(parsedJson['longitude'].toString()),
    );
  }
}
