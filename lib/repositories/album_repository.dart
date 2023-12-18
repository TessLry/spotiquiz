import 'dart:convert';

import 'package:http/http.dart';
import 'package:spotiquiz/models/album.dart';
import 'package:spotiquiz/utils/credentials.dart';

class AlbumRepository {
  Future<List<Album>> getAlbumInfo(String query) async {
    final response = await get(
      Uri.parse(
          'https://api.spotify.com/v1/search?q=$query&type=album&market=FR&limit=3&offset=0'),
      headers: {
        'Authorization': 'Bearer ${AppCredentials.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final List<Album> albums = [];

      final Map<String, dynamic> albumInfo = jsonDecode(response.body);

      if (albumInfo.containsKey("albums")) {
        for (final Map<String, dynamic> album in albumInfo["albums"]["items"]) {
          albums.add(Album(
            id: album["id"],
            name: album["name"],
            image: album["images"].length > 0 ? album["images"][2]["url"] : "",
            releaseDate: album["release_date"],
          ));
        }
      }

      return albums;
    } else {
      throw Exception('Failed to load artist');
    }
  }
}
