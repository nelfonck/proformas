class Helpers{
  static Map<String, dynamic> castMap(dynamic map) {
    if (map is Map) {
      return map.map((key, value) {
        return MapEntry(
          key.toString(),
          value is Map ? castMap(value) : value,
        );
      });
    }
    return {};
  }
}