part of 'app_maneger_bloc.dart';

@immutable
sealed class AppManegerState {}

final class AppManegerInitial extends AppManegerState {}

class Authenticated extends AppManegerState{}

class Unauthenticated extends AppManegerState{}