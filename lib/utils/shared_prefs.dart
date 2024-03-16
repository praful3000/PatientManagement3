import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences pref;
  storeUser(user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('user', user);
  }

  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('user');
  }

  removeUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove('user');
  }
}
