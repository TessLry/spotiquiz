import 'package:flutter/material.dart';
import 'package:spotiquiz/models/artist.dart';
import 'package:spotiquiz/repositories/artist_repository.dart';
import 'package:spotiquiz/utils/colors.dart';

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
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          labelText: 'Artiste',
          labelStyle: const TextStyle(color: AppColors.primary),
          suffixIcon: _isFind
              ? const Icon(Icons.check, color: AppColors.primary)
              : const Icon(Icons.search, color: Colors.grey),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2.0),
          ),
          focusColor: AppColors.primary,
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
      ListView.builder(
        primary: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _artists.length,
        itemBuilder: (BuildContext context, int index) {
          final Artist artist = _artists[index];
          return ListTile(
            title: Text(artist.name),
            leading: artist.image == null
                ? const Icon(Icons.person, size: 50)
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
      )
    ]);
  }
}
