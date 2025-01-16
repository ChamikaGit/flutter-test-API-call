import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_sample_api/features/post/models/post_data_model.dart';
import 'package:flutter_bloc_sample_api/features/post/repos/post_repo.dart';
import 'package:meta/meta.dart';


part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<PostInitialFetchEvent>(postInitialFetchEvent);
    on<PostAddEvent>(postAddEvent);
  }

  FutureOr<void> postInitialFetchEvent(PostInitialFetchEvent event, Emitter<PostState> emit) async {
    emit(PostLoadingState());
    await Future.delayed(const Duration(seconds: 3));
    List<PostDataModel> postList = await PostRepo.fetchAllPosts();
    emit(PostFetchingSuccessListState(postDataList: postList));
  }

  Future<void> postAddEvent(PostAddEvent event, Emitter<PostState> emit) async {
    try {
      final isAdded = await PostRepo.addPost();
      if (isAdded) {
        emit(PostSuccessfullyAddedStatus(isAddedPost: isAdded));
      } else {
        emit(PostErrorState(message: "Failed to add post."));
      }
    } catch (e) {
      emit(PostErrorState(message: "Error adding post: ${e.toString()}"));
    }
  }

}
