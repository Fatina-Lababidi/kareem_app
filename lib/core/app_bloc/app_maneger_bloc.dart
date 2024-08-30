import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_maneger_event.dart';
part 'app_maneger_state.dart';

class AppManegerBloc extends Bloc<AppManegerEvent, AppManegerState> {
  AppManegerBloc() : super(AppManegerInitial()) {
    on<CheckAuthStatus>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    });
  }
}
