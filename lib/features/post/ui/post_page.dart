import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_sample_api/features/post/bloc/post_bloc.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late PostBloc postBloc;

  @override
  void initState() {
    super.initState();
    postBloc = PostBloc();
    postBloc.add(PostInitialFetchEvent());
    super.initState();
  }

  @override
  void dispose() {
    postBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Trigger adding a new post.
          postBloc.add(PostAddEvent());
        },
        label: const Text("Add"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: BlocConsumer<PostBloc, PostState>(
        bloc: postBloc,
        listenWhen: (previous, current) => current is PostActionState,
        buildWhen: (previous, current) => current is! PostActionState,
        listener: (context, state) {
          if (state is PostSuccessfullyAddedStatus) {
            // Show success message.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Post added successfully!")),
            );
          } else if (state is PostErrorState) {
            // Show error message.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.message}")),
            );
          }
        },
        builder: (context, state) {
          if (state is PostLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostFetchingSuccessListState) {
            var list = state.postDataList;
            print("list is : ${list}");
            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(8),
                    color: Colors.grey.shade200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list[index].title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 4,),
                        Text(
                          list[index].body,
                          maxLines: 3,
                          style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Colors.black45),
                        )
                      ],
                    ),
                  );
                });
          } else if (state is PostErrorState) {
            // Show error state if something goes wrong.
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else {
            // Default state when nothing is loaded.
            return const Center(child: Text("No data available."));
          }
        },
      ),
    );
  }
}
