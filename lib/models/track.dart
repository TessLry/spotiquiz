import 'package:spotiquiz/models/Artist.dart';
import 'package:spotiquiz/models/album.dart';

class Track {
  final int id;
  final String name;
  final bool isPlayable;
  final String? previewUrl;
  final Album album;
  final Artist artist;

  Track(
      {required this.id,
      required this.name,
      required this.isPlayable,
      required this.album,
      required this.artist,
      this.previewUrl});
}
