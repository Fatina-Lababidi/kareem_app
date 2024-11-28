part of 'app_maneger_bloc.dart';

@immutable
sealed class AppManegerState {}

final class AppManegerInitial extends AppManegerState {}

class Authenticated extends AppManegerState {}//useingApp

class Unauthenticated extends AppManegerState {}

class FirstTimeUser extends AppManegerState{}

//class ReturningUser extends AppManegerState{}
//class LoggedOut extends AppManegerState {}
