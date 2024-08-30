part of 'app_maneger_bloc.dart';

@immutable
sealed class AppManegerEvent {}

class CheckAuthStatus extends AppManegerEvent{}