import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/shared/share_preference.dart';
GetIt locator = GetIt.instance;

void setupDi(){
  locator.registerLazySingletonAsync<PersistentStorage>(()async{
    final result = await SharedPreferences.getInstance();
    return PersistentStorage(preferences: result);
  });
}