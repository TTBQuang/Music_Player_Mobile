import 'package:flutter/material.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/layers/presentation/main_page/main_viewmodel.dart';
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
    HomeScreen(), // Màn hình chính
    LibraryScreen(), // Màn hình thư viện
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(builder: (context, viewModel, child) {
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
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context);
    MainViewModel viewModel = Provider.of<MainViewModel>(context);
    User? user = loginViewModel.user;

    return Center(
      child: Column(
        children: [
          FilledButton(
              onPressed: () {
                ToastUtil.showToast("message");
              },
              child: Text(user?.username ?? '123')),
          FilledButton(
              onPressed: () {
                if (user != null) {
                  viewModel.logout().then((_) {
                    loginViewModel.user = null;
                    Navigator.of(context).pushAndRemoveUntil(
                      LoginScreen.route(popToPreviousScreen: false),
                          (Route<dynamic> route) => false,
                    );
                  });
                } else {
                  final route = LoginScreen.route(popToPreviousScreen: true);
                  Navigator.of(context).push(route);
                }
              },
              child: const Text("User")),
          if (user?.authority == 'admin')
            FilledButton(
              onPressed: () {
                viewModel.logout().then((_) {
                  loginViewModel.user = null;
                  Navigator.of(context).pushAndRemoveUntil(
                    LoginScreen.route(popToPreviousScreen: false),
                        (Route<dynamic> route) => false,
                  );
                });
              },
              child: const Text("Admin"),
            ),
        ],
      ),
    );
  }
}

class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Library Screen'),
    );
  }
}
