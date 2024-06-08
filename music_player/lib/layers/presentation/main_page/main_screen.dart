import 'package:flutter/material.dart';
import 'package:music_player/layers/presentation/base_screen.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/layers/presentation/main_page/main_viewmodel.dart';
import 'package:music_player/layers/presentation/main_page/widget/library_screen.dart';
import 'package:music_player/layers/presentation/main_page/widget/main_home_screen.dart';
import 'package:music_player/layers/presentation/main_page/widget/profile_dialog.dart';
import 'package:music_player/layers/presentation/search_song_page/search_song_screen.dart';
import 'package:provider/provider.dart';

import '../../../utils/strings.dart';
import '../login_page/login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) {
        return const MainScreen();
      },
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MainHomeScreen(),
    const LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScreen(() =>
        Consumer<MainViewModel>(builder: (context, viewModel, child) {
          LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context);

          void showProfileDialog(BuildContext context) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const ProfileDialog();
              },
            );
          }

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _selectedIndex == 0
                ? AppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        if (loginViewModel.user != null) {
                          showProfileDialog(context);
                        } else {
                          Navigator.of(context).push(
                            LoginScreen.route(canNavigateBack: true),
                          );
                        }
                      },
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          Navigator.of(context).push(SearchSongScreen.route());
                        },
                      ),
                    ],
                  )
                : null,
            body: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: Strings.home,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_library),
                  label: Strings.library,
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).colorScheme.tertiary,
              onTap: _onItemTapped,
            ),
          );
        }));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
