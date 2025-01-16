part of 'post_bloc.dart';

@immutable
sealed class PostState {}

sealed class PostActionState extends PostState{

}


final class PostInitial extends PostState {}

class PostLoadingState extends PostState {}

class PostFetchingSuccessListState extends PostState {
  final List<PostDataModel> postDataList;

  PostFetchingSuccessListState({required this.postDataList});
}

class PostErrorState extends PostState {
  final String message;

  PostErrorState({required this.message});
}

class PostSuccessfullyAddedStatus extends PostActionState{
  final bool isAddedPost;

  PostSuccessfullyAddedStatus({
    required this.isAddedPost,
  });
}
