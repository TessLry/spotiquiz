import 'package:flutter/material.dart';
import 'package:spotiquiz/models/album.dart';
import 'package:spotiquiz/repositories/album_repository.dart';
import 'package:spotiquiz/utils/colors.dart';

class SearchAlbum extends StatefulWidget {
  final ValueChanged<Album> onToggle;

  const SearchAlbum({super.key, required this.onToggle});

  @override
  State<SearchAlbum> createState() => _SearchAlbumState();
}

class _SearchAlbumState extends State<SearchAlbum> {
  List<Album> _albums = [];
  final TextEditingController _textFieldController = TextEditingController();
  bool _isFind = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextField(
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
            labelText: 'Album',
            labelStyle: const TextStyle(color: AppColors.primary),
            suffixIcon: _isFind
                ? const Icon(Icons.check, color: AppColors.primary)
                : const Icon(Icons.search, color: Colors.grey),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2.0),
            ),
            focusColor: AppColors.primary),
        controller: _textFieldController,
        onChanged: (String value) async {
          if (value == "" || value.trim().length < 2) {
            setState(() {
              _albums = [];
            });
            return;
          }
          _isFind = false;
          final AlbumRepository albumRepository = AlbumRepository();
          final List<Album> albums = await albumRepository.getAlbumInfo(value);
          setState(() {
            _albums = albums;
          });
        },
      ),
      ListView.builder(
        primary: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _albums.length,
        itemBuilder: (BuildContext context, int index) {
          final Album album = _albums[index];
          return ListTile(
            title: Text(album.name),
            leading: album.image == null
                ? const Icon(Icons.album, size: 50)
                : Image.network(album.image!,
                    fit: BoxFit.cover, width: 50, height: 50),
            onTap: () {
              setState(() {
                _textFieldController.text = album.name;
                _isFind = true;
                _albums = [];
              });
              widget.onToggle(album);
            },
          );
        },
      )
    ]);
  }
}
