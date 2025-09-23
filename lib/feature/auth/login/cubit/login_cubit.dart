import 'package:flutter_base_app/core/network/network_manager/network_manager.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_state.dart';
import 'package:flutter_base_app/feature/auth/login/service/i_login_service.dart';
import 'package:flutter_base_app/feature/auth/login/service/login_service.dart';
import 'package:flutter_base_app/product/injector/injector.dart';
import 'package:flutter_base_app/product/storage/local_get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.initial()) {
    init();
  }

  final ILoginService _loginService = LoginService(NetworkManager.instance);

  init() async {}

  // Future<void> userLogin(String emailOrPhone, String password) async {
  //   emit(state.copyWith(loginState: LoginStates.loading, errorMessage: ''));
  //   final response = await _loginService.userLogin(emailOrPhone, password);

  //   if (response == null) {
  //     emit(
  //       state.copyWith(
  //         loginState: LoginStates.error,
  //         errorMessage:
  //             'Veriler yüklenemedi. Lütfen internet bağlantınızı kontrol ediniz...',
  //       ),
  //     );
  //   } else {
  //     if (response.success!) {
  //       injector.get<LocalStorage>().saveString('token', 'token Değeri');

  //       emit(
  //         state.copyWith(
  //           loginState: LoginStates.completed,
  //           message: response.message,
  //         ),
  //       );
  //     } else {
  //       emit(state.copyWith(
  //         loginState: LoginStates.error,
  //         errorMessage: response.errorMessage ?? 'Bir Hata Oluştu!',
  //       ));
  //     }
  //   }
  // }

  //  Future<void> fetchUniversityList(int universityId) async {
  //   emit(state.copyWith(appointedState: AppointedStates.loading, errorMessage: ''));
  //   final response = await _universityService.fetchUniversityList();

  //   if (response == null) {
  //     emit(
  //       state.copyWith(
  //         appointedState: AppointedStates.error,
  //         errorMessage: 'Veriler yüklenemedi. Lütfen internet bağlantınızı kontrol ediniz...',
  //       ),
  //     );
  //   } else {
  //     if (response.success!) {
  //       final dataList = response.data as List<dynamic>;
  //       emit(
  //         state.copyWith(
  //             appointedState: AppointedStates.completed, universityList: dataList.map((dynamic item) => UniversityModel.fromJson(item as Map<String, dynamic>)).toList(), universityId: universityId),
  //       );
  //     } else {
  //       emit(state.copyWith(
  //         appointedState: AppointedStates.error,
  //         errorMessage: response.errorMessage ?? 'Bir Hata Oluştu!',
  //       ));
  //     }
  //   }
  // }
}
