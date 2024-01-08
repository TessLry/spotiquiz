import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotiquiz/models/track.dart';

class TrackCubit extends Cubit<List<Track>> {
  TrackCubit() : super([]);

  Future<void> setTracks(List<Track> tracks) async {
    emit(tracks);
  }

  Future<void> addTrack(Track track) async {
    emit([...state, track]);
  }

  Future<void> removeTrack() async {
    state.removeAt(0);
    emit(state);
  }
}
