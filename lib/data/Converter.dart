import 'package:exif/exif.dart';

class Converter {
  static DateTime exifToDate(Map<String, IfdTag> data) {
    var exifDateTime = data['Image DateTime']
        .toString()
        .replaceAll(':', '')
        .replaceFirst(' ', 'T');
    return DateTime.parse(exifDateTime);
  }
}
