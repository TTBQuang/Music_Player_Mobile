import 'package:flutter/material.dart';
import 'package:music_player/layers/presentation/main_page/main_viewmodel.dart';
import 'package:music_player/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../../../utils/strings.dart';
import '../../../domain/entity/user.dart';
import '../../login_page/login_screen.dart';
import '../../login_page/login_viewmodel.dart';

class ProfileDialog extends StatefulWidget {
  const ProfileDialog({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileDialogState();
  }
}

class _ProfileDialogState extends State<ProfileDialog> {
  late TextEditingController _displayNameController;

  // use to show info in dialog and when user change info but haven't saved yet
  User? userTmp;

  @override
  void initState() {
    super.initState();
    LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    userTmp = loginViewModel.user?.clone();
    _displayNameController =
        TextEditingController(text: userTmp?.displayName ?? '');
  }

  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context);
    MainViewModel mainViewModel = Provider.of<MainViewModel>(context);

    void logout() {
      loginViewModel.user = null;
      // delete credentials in local storage
      mainViewModel.deleteCredentials();
      // navigate back to login screen
      Navigator.of(context).pushAndRemoveUntil(
        LoginScreen.route(canNavigateBack: false),
        (Route<dynamic> route) => false,
      );
    }

    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              userTmp?.username ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(
                labelText: Strings.displayName,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _displayNameController.text = value;
                  userTmp?.displayName = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      bool isSuccess = await mainViewModel.updateUser(userTmp!);
                      if (isSuccess) {
                        loginViewModel.user = userTmp;
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      } else {
                        ToastUtil.showToast(mainViewModel.errorMessage);
                      }
                    },
                    child: const Text(Strings.update),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton(
                    onPressed: logout,
                    child: const Text(Strings.logout),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }
}
