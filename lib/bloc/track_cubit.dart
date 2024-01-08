import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotiquiz/models/artist.dart';
import 'package:spotiquiz/models/album.dart';
import 'package:spotiquiz/models/track.dart';

class TrackCubit extends Cubit<List<Track>> {
  TrackCubit() : super([]);

  Future<void> loadTracks() async {
    emit([
      Track(
          id: '1',
          name: 'Track 1',
          isPlayable: true,
          previewUrl:
              "https://p.scdn.co/mp3-preview/9dd0f5f1cad12520a4666e6e0e6d40fd68449596?cid=1f4c9a02a92f4e9989a00dc8f91c2fa3",
          album: Album(
              id: '1',
              name: 'Album 1',
              image:
                  'https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228',
              releaseDate: '2023-12-16'),
          artist: Artist(id: '1', name: 'Artist 1')),
      Track(
          id: '2',
          name: 'Track 2',
          isPlayable: true,
          previewUrl:
              "https://p.scdn.co/mp3-preview/464aaab708a6e5cde70994d77bfda21395d7d9f7?cid=1f4c9a02a92f4e9989a00dc8f91c2fa3",
          album: Album(
              id: '2',
              name: 'Album 2',
              image:
                  'https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228',
              releaseDate: '2023-12-16'),
          artist: Artist(id: '2', name: 'Artist 2')),
      Track(
          id: '3',
          name: 'Track 3',
          isPlayable: true,
          previewUrl:
              "https://p.scdn.co/mp3-preview/b25ea634fb5aabe7d6dba3cad603a590e09afbdd?cid=1f4c9a02a92f4e9989a00dc8f91c2fa3",
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

  Future<void> removeTrack() async {
    // emit(state.sublist(1));
    //Remove the first element of the list
    state.removeAt(0);
    emit(state);
  }
}
