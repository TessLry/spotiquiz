import 'package:flutter/material.dart';
import 'package:spotiquiz/models/album.dart';
import 'package:spotiquiz/repositories/album_repository.dart';

class SearchAlbum extends StatefulWidget {
  const SearchAlbum({super.key});

  @override
  State<SearchAlbum> createState() => _SearchAlbumState();
}

class _SearchAlbumState extends State<SearchAlbum> {
  List<Album> _albums = [];
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextField(
        decoration: const InputDecoration(
          labelText: 'Album',
          labelStyle: TextStyle(color: Colors.green),
        ),
        controller: _textFieldController,
        onChanged: (String value) async {
          if (value.trim().length < 2) return;
          final AlbumRepository albumRepository = AlbumRepository();
          final List<Album> albums = await albumRepository.getAlbumInfo(value);
          setState(() {
            _albums = albums;
          });
        },
      ),
      Expanded(
          child: ListView.builder(
        itemCount: _albums.length,
        itemBuilder: (BuildContext context, int index) {
          final Album album = _albums[index];
          return ListTile(
            title: Text(album.name),
            leading: Image.network(album.image ?? ""),
          );
        },
      ))
    ]);
  }
}
