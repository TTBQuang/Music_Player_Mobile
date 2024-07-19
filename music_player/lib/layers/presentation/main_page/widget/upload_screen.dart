import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:music_player/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../../../utils/strings.dart';
import '../../../domain/entity/genre.dart';
import '../../../domain/entity/singer.dart';
import '../../../domain/entity/uploaded_song.dart';
import '../../base_screen.dart';
import '../main_viewmodel.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _songController = TextEditingController();
  String? _selectedSinger;
  String? _selectedGenre;
  List<Singer> _singers = [];
  List<Genre> _genres = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String? _mp3Path;
  String? _imagePath;
  MainViewModel? mainViewModel;

  @override
  void initState() {
    super.initState();
    mainViewModel = Provider.of<MainViewModel>(context, listen: false);
    _loadData();
  }

  // load singers list and genres list
  Future<void> _loadData() async {
    try {
      final singers = await mainViewModel?.getAllSingers();
      final genres = await mainViewModel?.getAllGenres();
      setState(() {
        _singers = singers!;
        _genres = genres!;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = Strings.errorOccurred;
        _isLoading = false;
      });
    }
  }

  // pick a file base on file type
  Future<void> _pickFile(FileType fileType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: fileType,
    );

    if (result != null) {
      setState(() {
        if (fileType == FileType.audio) {
          _mp3Path = result.files.single.path;
        } else if (fileType == FileType.image) {
          _imagePath = result.files.single.path;
        }
      });
    }
  }

  // upload files, then create an UploadedSong object base on input and links to uploaded file
  Future<UploadedSong?> _uploadFiles() async {
    final mainViewModel = Provider.of<MainViewModel>(context, listen: false);

    try {
      List<Future<String?>> uploadTasks = [];
      if (_mp3Path != null) {
        uploadTasks.add(mainViewModel.upload(_mp3Path!, 'song/music'));
      }
      if (_imagePath != null) {
        uploadTasks.add(mainViewModel.upload(_imagePath!, 'song/image'));
      }

      List<String?> urls = await Future.wait(uploadTasks);

      // get uploaded files' link
      String? mp3Url = urls.isNotEmpty ? urls[0] : null;
      String? imageUrl = urls.length > 1 ? urls[1] : null;

      if (mp3Url != null && imageUrl != null) {
        return UploadedSong(
          name: _songController.text,
          singerId: _singers
              .firstWhere((singer) => singer.name == _selectedSinger)
              .id,
          genreId:
              _genres.firstWhere((genre) => genre.name == _selectedGenre).id,
          songLink: mp3Url,
          imageLink: imageUrl,
        );
      } else {
        ToastUtil.showToast(Strings.uploadFail);
        return null;
      }
    } catch (e) {
      ToastUtil.showToast(e.toString());
      return null;
    }
  }

  // check input, then upload files
  Future<UploadedSong?> _handleUpload() async {
    if (_songController.text.isEmpty ||
        _selectedSinger == null ||
        _selectedGenre == null ||
        _mp3Path == null ||
        _imagePath == null) {
      ToastUtil.showToast(Strings.requestFillAll);
      return null;
    }

    final uploadedSong = await _uploadFiles();

    if (uploadedSong != null) {
      return uploadedSong;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    return BaseScreen(() => Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      Strings.addSong,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      controller: _songController,
                      decoration: const InputDecoration(
                        labelText: Strings.songName,
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton<String>(
                        value: _selectedSinger,
                        hint: const Text(Strings.chooseSinger),
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSinger = newValue;
                          });
                        },
                        underline: const SizedBox.shrink(),
                        items: _singers.map((Singer singer) {
                          return DropdownMenuItem<String>(
                            value: singer.name,
                            child: Text(singer.name),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton<String>(
                        value: _selectedGenre,
                        hint: const Text(Strings.chooseGenre),
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGenre = newValue;
                          });
                        },
                        underline: const SizedBox.shrink(),
                        items: _genres.map((Genre genre) {
                          return DropdownMenuItem<String>(
                            value: genre.name,
                            child: Text(genre.name),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            _mp3Path ?? Strings.song,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _pickFile(FileType.audio),
                        child: const Text(Strings.choose),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            _imagePath ?? Strings.image,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _pickFile(FileType.image),
                        child: const Text(Strings.choose),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        UploadedSong? uploadedSong = await _handleUpload();
                        if (uploadedSong != null) {
                          bool isSuccess =
                              await mainViewModel?.uploadSong(uploadedSong) ??
                                  false;
                          if (isSuccess) {
                            ToastUtil.showToast(Strings.addSuccessfully);
                          }
                        } else {
                          ToastUtil.showToast(Strings.addFailed);
                        }
                      },
                      child: Text(
                        Strings.addSong,
                        style: TextStyle(fontSize: 12.w),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
