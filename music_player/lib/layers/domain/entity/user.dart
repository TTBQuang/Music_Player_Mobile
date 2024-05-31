class User {
  int id;
  String username;
  String password;
  String displayName;
  String authority;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.displayName,
    required this.authority,
  });

  User clone() {
    return User(
      id: id,
      username: username,
      displayName: displayName,
      password: password,
      authority: authority,
    );
  }
}
