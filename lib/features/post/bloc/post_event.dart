part of 'post_bloc.dart';

@immutable
sealed class PostEvent {}

sealed class PostActionEvent extends PostEvent{}

class PostInitialFetchEvent extends PostEvent{}

class PostAddEvent extends PostActionEvent{}

