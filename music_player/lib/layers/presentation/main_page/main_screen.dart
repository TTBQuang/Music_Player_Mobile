import 'package:flutter/material.dart';
import 'package:music_player/layers/presentation/base_screen.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/layers/presentation/main_page/main_viewmodel.dart';
import 'package:music_player/layers/presentation/main_page/widget/library_screen.dart';
import 'package:music_player/layers/presentation/main_page/widget/main_home_screen.dart';
import 'package:music_player/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../../utils/strings.dart';
import '../../domain/entity/user.dart';
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
    MainHomeScreen(), // Màn hình chính
    LibraryScreen(), // Màn hình thư viện
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        () => Consumer<MainViewModel>(builder: (context, viewModel, child) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: _selectedIndex == 0
                    ? AppBar(
                        leading: IconButton(
                          icon: const Icon(Icons.person),
                          onPressed: () {
                            // Handle person icon action
                          },
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              // Handle search action
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


