
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;
String? _account;
String? get account{
  return _account;
}
set account(String? account){
  if(account==null){
    preferences.remove(ACCOUNT);
  }else{
    preferences.setString(ACCOUNT, account);
  }

  _account=account;
}
String ACCOUNT="account";