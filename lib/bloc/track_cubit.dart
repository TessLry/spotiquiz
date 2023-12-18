import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotiquiz/models/Artist.dart';
import 'package:spotiquiz/models/album.dart';
import 'package:spotiquiz/models/track.dart';

class TrackCubit extends Cubit<List<Track>> {
  TrackCubit() : super([]);

  Future<void> loadTracks() async {
    emit([
      Track(
          id: 1,
          name: 'Track 1',
          isPlayable: true,
          album: Album(
              id: '1',
              name: 'Album 1',
              image:
                  'https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228',
              releaseDate: '2023-12-16'),
          artist: Artist(id: '1', name: 'Artist 1')),
      Track(
          id: 2,
          name: 'Track 2',
          isPlayable: true,
          album: Album(
              id: '2',
              name: 'Album 2',
              image:
                  'https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228',
              releaseDate: '2023-12-16'),
          artist: Artist(id: '2', name: 'Artist 2')),
      Track(
          id: 3,
          name: 'Track 3',
          isPlayable: true,
          album: Album(
              id: '3',
              name: 'Album 3',
              image:
                  'https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228',
              releaseDate: '2023-12-16'),
          artist: Artist(id: '3', name: 'Artist 3')),
    ]);
  }

  Future<void> addTrack(Track track) async {
    emit([...state, track]);
  }
}
