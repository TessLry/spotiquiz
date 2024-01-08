import 'package:flutter/material.dart';
import 'package:spotiquiz/models/artist.dart';
import 'package:spotiquiz/repositories/artist_repository.dart';

class SearchArtist extends StatefulWidget {
  final ValueChanged<Artist> onToggle;

  const SearchArtist({super.key, required this.onToggle});

  @override
  State<SearchArtist> createState() => _SearchArtistState();
}

class _SearchArtistState extends State<SearchArtist> {
  List<Artist> _artists = [];
  final TextEditingController _textFieldController = TextEditingController();
  bool _isFind = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextField(
        decoration: InputDecoration(
          labelText: 'Artiste',
          labelStyle: TextStyle(color: Colors.green),
          suffixIcon: _isFind ? Icon(Icons.check) : Icon(Icons.search),
        ),
        controller: _textFieldController,
        onChanged: (String value) async {
          if (value == "" || value.trim().length < 2) {
            setState(() {
              _artists = [];
            });
            return;
          }
          _isFind = false;
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
            leading: artist.image == null
                ? Icon(Icons.person, size: 50)
                : Image.network(artist.image!,
                    fit: BoxFit.cover, width: 50, height: 50),
            onTap: () {
              setState(() {
                _textFieldController.text = artist.name;
                _isFind = true;
                _artists = [];
              });
              widget.onToggle(artist);
            },
          );
        },
      ))
    ]);
  }
}
