import 'package:get_it/get_it.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings_page/storage_repo.dart';
import 'package:flutter_kirthan/view_controller/user_controller.dart';
import 'package:flutter_kirthan/models/user.dart';


final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<SignInService>(SignInService());
  locator.registerSingleton<StorageRepo>(StorageRepo());
  locator.registerSingleton<UserController>(UserController());
  // locator.registerFactory<UserRequest>(() => UserRequest());
  // locator.registerSingleton<contact_details_profile>(contact_details_profile());
  // locator.registerSingleton<UserRequest>(UserRequest());
}
