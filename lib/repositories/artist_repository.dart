import 'dart:convert';

import 'package:spotiquiz/models/artist.dart';
import 'package:spotiquiz/utils/credentials.dart';
import 'package:http/http.dart';

class ArtistRepository {
  Future<List<Artist>> getArtistInfo(String query) async {
    final response = await get(
      Uri.parse(
          'https://api.spotify.com/v1/search?q=$query&type=artist&market=FR&limit=3&offset=0'),
      headers: {
        'Authorization': 'Bearer ${AppCredentials.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final List<Artist> artists = [];

      final Map<String, dynamic> artistInfo = jsonDecode(response.body);

      if (artistInfo.containsKey("artists")) {
        for (final Map<String, dynamic> artist in artistInfo["artists"]
            ["items"]) {
          artists.add(Artist(
            id: artist["id"],
            name: artist["name"],
            image:
                artist["images"].length > 0 ? artist["images"][2]["url"] : null,
          ));
        }
      }

      return artists;
    } else {
      throw Exception('Failed to load artist');
    }
  }
}
