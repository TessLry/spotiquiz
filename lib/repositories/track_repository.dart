import 'dart:convert';

import 'package:http/http.dart';
import 'package:spotiquiz/models/artist.dart';
import 'package:spotiquiz/models/album.dart';
import 'package:spotiquiz/models/track.dart';
import 'package:spotiquiz/utils/credentials.dart';

class TrackRepository {
  Future<List<Track>> getTracksByArtist(Artist artist, int nbQuestion) async {
    String artistName = artist.name.replaceAll(" ", "%20");
    final response = await get(
      Uri.parse(
          'https://api.spotify.com/v1/search?q=artist%3A$artistName&type=track&market=FR&limit=$nbQuestion&offset=0'),
      headers: {
        'Authorization': 'Bearer ${AppCredentials.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final List<Track> tracks = [];

      final Map<String, dynamic> trackInfo = jsonDecode(response.body);

      if (trackInfo.containsKey("tracks")) {
        for (final Map<String, dynamic> track in trackInfo["tracks"]["items"]) {
          tracks.add(Track(
            id: track["id"],
            name: track["name"],
            isPlayable: track["is_playable"],
            previewUrl: track["preview_url"],
            album: Album(
              id: track["album"]["id"],
              name: track["album"]["name"],
              image: track["album"]["images"].length > 0
                  ? track["album"]["images"][2]["url"]
                  : null,
              releaseDate: track["album"]["release_date"],
            ),
            artist: artist,
          ));
        }
      }
      return tracks;
    } else {
      throw Exception('Failed to load tracks');
    }
  }

  Future<List<Track>> getTracksByAlbum(Album album, int nbQuestion) async {
    String albumName = album.name.replaceAll(" ", "%20");
    final response = await get(
      Uri.parse(
          'https://api.spotify.com/v1/search?q=album%3A$albumName&type=track&market=FR&limit=$nbQuestion&offset=0'),
      headers: {
        'Authorization': 'Bearer ${AppCredentials.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final List<Track> tracks = [];

      final Map<String, dynamic> trackInfo = jsonDecode(response.body);

      if (trackInfo.containsKey("tracks")) {
        for (final Map<String, dynamic> track in trackInfo["tracks"]["items"]) {
          tracks.add(Track(
              id: track["id"],
              name: track["name"],
              isPlayable: track["is_playable"],
              previewUrl: track["preview_url"],
              album: album,
              artist: Artist(
                id: track["artists"][0]["id"],
                name: track["artists"][0]["name"],
                image: null,
              )));
        }
      }
      return tracks;
    } else {
      throw Exception('Failed to load tracks');
    }
  }
}
