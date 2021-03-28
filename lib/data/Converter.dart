import 'package:exif/exif.dart';
import 'package:socialpixel/data/models/location.dart';

class Converter {
  static DateTime exifToDate(Map<String, IfdTag> data) {
    var exifDateTime = data['Image DateTime']
        .toString()
        .replaceAll(':', '')
        .replaceFirst(' ', 'T');
    return DateTime.parse(exifDateTime);
  }

  static Location exifToLocation(Map<String, IfdTag> data) {
    if (data.containsKey('GPS GPSLatitude')) {
      var exifLat = data['GPS GPSLatitude'].values;
      var lat = (exifLat[0].numerator / exifLat[0].denominator) +
          ((exifLat[1].numerator / exifLat[1].denominator) / 60) +
          ((exifLat[2].numerator / exifLat[2].denominator) / 3600);
      var exifLong = data['GPS GPSLongitude'].values;
      var long = (exifLong[0].numerator / exifLong[0].denominator) +
          ((exifLong[1].numerator / exifLong[1].denominator) / 60) +
          ((exifLong[2].numerator / exifLong[2].denominator) / 3600);
      return Location(latitude: lat, longitude: long);
    }
    return null;
  }

  static String dateTimeStringtoReadable(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();
    if (dateTime.day == now.day) {
      var add = dateTime.hour < 10 ? '0' : '';
      return '$add${dateTime.hour}:${dateTime.minute}';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}
