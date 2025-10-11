import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial()) {
    init();
  }

  //final IGlobalService _globalService = GlobalService(NetworkManager.instance);

  Future<void> init() async {
    // TODO: implement init logic
  }
}
