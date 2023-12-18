import 'package:flutter/material.dart';
import 'package:spotiquiz/models/artist.dart';
import 'package:spotiquiz/repositories/artist_repository.dart';

class SearchArtist extends StatefulWidget {
  const SearchArtist({super.key});

  @override
  State<SearchArtist> createState() => _SearchArtistState();
}

class _SearchArtistState extends State<SearchArtist> {
  List<Artist> _artists = [];
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextField(
        decoration: const InputDecoration(
          labelText: 'Artiste',
          labelStyle: TextStyle(color: Colors.green),
        ),
        controller: _textFieldController,
        onChanged: (String value) async {
          if (value.trim().length < 3) return;
          final ArtistRepository artistRepository = ArtistRepository();
          final List<Artist> artists =
              await artistRepository.getArtistInfo(value);
          setState(() {
            _artists = artists;
          });
        },
      ),
      Expanded(
          child: ListView.builder(
        itemCount: _artists.length,
        itemBuilder: (BuildContext context, int index) {
          final Artist artist = _artists[index];
          return ListTile(
            title: Text(artist.name),
            leading: Image.network(artist.image ?? ""),
          );
        },
      ))
    ]);
  }
}
