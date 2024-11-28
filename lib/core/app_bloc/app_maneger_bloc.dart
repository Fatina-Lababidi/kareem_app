import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_maneger_event.dart';
part 'app_maneger_state.dart';

class AppManegerBloc extends Bloc<AppManegerEvent, AppManegerState> {
  AppManegerBloc() : super(AppManegerInitial()) {
    on<CheckAuthStatus>(
      (event, emit) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        final isFirstTime = prefs.getBool('isFirstTime') ?? true;
        print(isFirstTime);
        print(token);
        if (token != null && token.isNotEmpty) {
          if (isFirstTime) {
            emit(FirstTimeUser());
          } else {
            emit(Authenticated());
          }
        } else {
          if (isFirstTime) {
            emit(FirstTimeUser());
          } else {
            emit(Unauthenticated());
          }
        }
      },
    );
    on<Logout>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('token');
      await prefs.remove('clientId');
      await prefs.remove('haveWallet'); //! have to find better solution
      print('token deleted');
      emit(Unauthenticated());
    });
  }
}
