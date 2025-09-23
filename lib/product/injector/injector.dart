import 'package:flutter_base_app/product/storage/local_get_storage.dart';
import 'package:get_it/get_it.dart';

//import 'injection.config.dart';

// Todo: injectable ile generate bir yapı oluşturulacak

final injector = GetIt.instance;

// genereic T type bir injector oluştur eager singleton ile

Future<void> initializeDependencies() async {
  //! Local Storage
  injector.registerSingleton<LocalStorage>(LocalStorage());

//   //! Routes App Page
//   injector.registerSingleton<AppPages>(AppPages());

// //!image compression
//   injector.registerSingleton<ImageCompression>(ImageCompression());
  //! image picker
  // injector.registerSingleton<FileImagePicker>(FileImagePicker());
  // injector.registerSingleton<ImageCompression>(ImageCompression());

  // //! Register User UseCase
  // //* Register User UseCase
  // injector.registerSingleton<UserDataSource>(
  //     UserDataSource(NetworkManager.instance.dio));
  // injector.registerSingleton<UserRepository>(
  //     UserRepositoryImpl(injector.get<UserDataSource>()));
  // injector.registerSingleton<UserUseCase>(
  //     UserUseCase(injector.get<UserRepository>()));
}
